class Weather < ApplicationRecord
  RAIN_FALL_JUDGMENT       = 3
  TAKE_WEATHER_HOUR        = 15
  RETRY_CALL_API_COUNT     = 3
  RETRY_CALL_API_WAIT_TIME = 5

  belongs_to :user,      optional: true
  belongs_to :line_user, optional: true

  validates :lat, numericality: { greater_than_or_equal_to: -45, less_than_or_equal_to: 45 },
                  allow_nil: true
  validates :lon, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 },
                  allow_nil: true

  def forecast
    @forecast ||= take_forecast
  end

  # OpenWeatherAPI から、天気予報を取得する
  # 取得できた場合 => 天気予報 Hash
  # 取得できない場合 => false
  def take_forecast
    retry_count = 0
    begin
      call_weather_api
    rescue OpenURI::HTTPError => e
      retry_count += 1
      retry_message(e, retry_count)
      retry_count <= RETRY_CALL_API_COUNT ? (sleep RETRY_CALL_API_WAIT_TIME; retry) : false
    end
  end

  # 今日の天気が雨である場合 => true
  # 今日の天気が雨ではない場合 => false
  def today_is_rainy?
    rain_falls = forecast[:hourly][0...TAKE_WEATHER_HOUR].map { |hourly| hourly[:rain][:'1h'] }
    rain_falls.find { |rain_fall| rain_fall >= RAIN_FALL_JUDGMENT }.present?
  end

  # text が OpenWeatherApi の city に対応しているか検証する
  # 対応している場合 => 天気予報Hash
  # 対応していない場合 => false
  def validate_city(text)
    city_name = text.slice(/(.+)[市区]/, 1) || text
    self.city = to_romaji(city_name)
    forecast
  end

  # OpenWeatherApi の city に対応するローマ字に変換する
  def to_romaji(text)
    kunrei_moji = Zipang.to_slug(text).gsub(/\-/, '').gsub(/m(?!(a|i|u|e|o|m))/, 'n').to_kunrei
    kunrei_moji.gsub(/si/, 'shi').gsub(/ti/, 'chi').gsub(/tu/, 'tsu')
  end

  def save_city
    save!
    line_user.update_attribute(:located_at, Time.zone.now)
  end

  def save_location(lat, lon)
    self.lat = lat.round(2)
    self.lon = lon.round(2)
    save!
    line_user.update_attribute(:located_at, Time.zone.now)
  end

  private

  # OpenWeatherAPI の OneCallAPI を呼び出す
  def call_weather_api
    base_url      = 'https://api.openweathermap.org/data/2.5/onecall?lang=ja'
    location      = "&lat=#{lat}&lon=#{lon}"
    exclude       = '&exclude=current,minutely,daily'
    app_id        = "&appid=#{Rails.application.credentials.open_weather_api[:app_key]}"

    api_response  = OpenURI.open_uri(base_url + location + exclude + app_id)
    json_forecast = JSON.parse(api_response.read, symbolize_names: true)
    refill_rain(json_forecast)
  end

  # OpenWeatherAPI の仕様により、天気が雨以外の場合は雨量が設定されていない
  # 天気が雨であっても、雨量が RAIN_FALL_JUDGMENT [mm] 以下の場合は、曇りとして扱いたい
  # そのため、以下2つの処理を行う
  #  - (1) 天気が雨以外の場合、雨量を 0[mm] に設定
  #  - (2) 雨量が 0 < RAIN_FALL_JUDGMENT [mm] の場合、天気を雨から曇りに変更
  def refill_rain(json_forecast)
    json_forecast[:hourly].each do |hourly|
      hourly[:rain] = { '1h': 0 }  if hourly[:rain].empty?
      rain_fall     = hourly[:rain][:'1h']

      next if rain_fall.zero? || RAIN_FALL_JUDGMENT <= rain_fall

      hourly[:weather].each do |weather|
        weather[:main]        = 'Clouds'
        weather[:description] = 'clouds'
      end
    end
  end

  def retry_message(exception, retry_count)
    if retry_count <= RETRY_CALL_API_COUNT
      logger.error "[Error] #{exception.class} が発生しました。"
      logger.error "#{RETRY_CALL_API_WAIT_TIME}sec 待機後に再接続します。"
      logger.error "この処理は#{RETRY_CALL_API_COUNT}回まで繰り返されます。(現在: #{retry_count}回目)"
    else
      logger.error "[Error]#{exception.class} の再接続に失敗しました。"
      logger.error exception.backtrace
    end
  end
end

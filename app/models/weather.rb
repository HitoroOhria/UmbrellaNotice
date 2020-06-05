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

  attr_accessor :city_forecast

  def forecast
    @forecast ||= one_call_api
  end

  # 今日の天気が雨である場合 => true
  # 今日の天気が雨ではない場合 => false
  def today_is_rainy?
    rain_falls = forecast[:hourly][0...TAKE_WEATHER_HOUR].map { |hourly| hourly[:rain][:'1h'] }
    rain_falls.find { |rain_fall| rain_fall >= RAIN_FALL_JUDGMENT }.present?
  end

  # text が CurrentWeatherAPI の city に対応しているか検証する
  # 対応している場合 => true
  # 対応していない場合 => false
  def city_is_valid?(text)
    city_name     = text.slice(/(.+)[市区]/, 1) || text
    self.city     = to_romaji(city_name)
    city_forecast = current_weather_api
    city_forecast.present?
  end

  # OpenWeatherApi の city に対応するローマ字に変換する
  def to_romaji(text)
    kunrei_moji = Zipang.to_slug(text).gsub(/\-/, '').gsub(/m(?!(a|i|u|e|o|m))/, 'n').to_kunrei
    kunrei_moji.gsub(/si/, 'shi').gsub(/ti/, 'chi').gsub(/tu/, 'tsu')
  end

  # 市名を使用して位置情報設定を行う場合
  #   => CurrentWeatherAPI を利用して、緯度・経度を保存する
  # GPS情報を使用して位置情報設定を行う場合
  #   => GPS情報の意図・経度を保存する
  def save_location(content)
    self.lat = (city_forecast.try(:[], :coord).try(:[], :lat) || content[:lat]).round(2)
    self.lon = (city_forecast.try(:[], :coord).try(:[], :lat) || content[:lon]).round(2)
    save!
    line_user.update_attribute(:located_at, Time.zone.now)
  end

  private

  def current_weather_api
    api_type      = 'weather'
    request_query = "&q=#{city}"
    take_api_and_error_handling(api_type, request_query)
  end

  def one_call_api
    api_type      = 'onecall'
    request_query = "&lat=#{lat}&lon=#{lon}&exclude=current,minutely,daily"
    take_api_and_error_handling(api_type, request_query)
  end

  # api_type に応じた OpenWeatherAPI から、天気予報を取得する
  # 天気予報取得時にエラーが発生した場合、3回までリトライする
  # 取得できた場合 => 天気予報 Hash
  # 取得できなかった場合 => false
  def take_api_and_error_handling(api_type, request_query)
    retry_count = 0
    begin
      call_weather_api(api_type, request_query)
    rescue OpenURI::HTTPError => e
      retry_count += 1
      retry_message(e, retry_count)
      retry_count <= RETRY_CALL_API_COUNT ? (sleep RETRY_CALL_API_WAIT_TIME; retry) : false
    end
  end

  # api_type に応じた　OpenWeatherAPI を呼び出す
  # OneCallAIP の場合、取得したデータに処理を加える
  def call_weather_api(api_type, request_query)
    base_url      = "http://api.openweathermap.org/data/2.5/#{api_type}?lang=ja"
    app_id        = "&appid=#{Rails.application.credentials.open_weather_api[:app_key]}"

    api_response  = OpenURI.open_uri(base_url + request_query + app_id)
    json_forecast = JSON.parse(api_response.read, symbolize_names: true)
    refill_rain(json_forecast) if api_type == 'onecall'
  end

  # OpenWeatherAPI の仕様により、天気が雨以外の場合は雨量が設定されていない
  # 天気が雨であっても、雨量が RAIN_FALL_JUDGMENT [mm] 以下の場合は、曇りとして扱いたい
  # そのため、以下2つの処理を行う
  #  - (1) 天気が雨以外の場合、雨量を 0[mm] に設定
  #  - (2) 雨量が 0 < RAIN_FALL_JUDGMENT [mm] の場合、天気を雨から曇りに変更
  def refill_rain(json_forecast)
    json_forecast[:hourly].each do |hourly|
      hourly[:rain] = { '1h': 0 }  if hourly[:rain].nil?
      rain_fall     = hourly[:rain][:'1h']

      next if rain_fall.zero? || RAIN_FALL_JUDGMENT <= rain_fall

      hourly[:weather].each do |weather|
        weather[:id]          = 804
        weather[:main]        = 'Clouds'
        weather[:description] = 'overcast clouds'
        weather[:icon]        = '04d'
      end
    end
    json_forecast
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

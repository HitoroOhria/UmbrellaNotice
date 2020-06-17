class Weather < ApplicationRecord
  include WEBrick::HTTPUtils

  belongs_to :user,      optional: true
  belongs_to :line_user, optional: true

  validates :city, format:       { with: /.+[市区]/, message: '市名の末尾に「市」か「区」を付ける必要があります' }
  validates :lat,  numericality: { greater_than_or_equal_to: -90,  less_than_or_equal_to: 90 }
  validates :lon,  numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  def romaji_city
    city_name = city.gsub(/[市区]/, '')
    romaji    = to_romaji(city_name)
    romaji[0].upcase + romaji[1..romaji.length]
  end

  def forecast
    @forecast ||= one_call_api
  end

  def today_is_rainy?
    rain_falls = forecast[:hourly][0...TAKE_WEATHER_HOUR].map { |hourly| hourly[:rain][:'1h'] }
    rain_falls.find { |rain_fall| rain_fall >= RAIN_FALL_JUDGMENT }.present?
  end

  # 引数の市名を座標に変換する
  # 変換に成功した場合 => save_location を呼び出す
  # 変換に失敗した場合 => nil を返す
  def take_and_save_location(city_name)
    city_name += '市' unless /.+[市区]/.match(city_name)
    self.city = city_name
    coord     = city_to_coord

    coord && save_location(coord[:lat], coord[:lon])
  end

  def save_location(lat, lon)
    self.lat = lat.round(2)
    self.lon = lon.round(2)

    save
    line_user.located_at || line_user.update_attributes(located_at: Time.zone.now, silent_notice: true)
    line_user.locating_from && line_user.update_attribute(:locating_from, nil)
  end

  private

  # self.city の市名の座標を返す
  # 有効な市名の場合 => { lat: Float, lon: Float }
  # 無効な市名の場合 => nil
  def city_to_coord
    xml_doc  = geocoding_api
    elements = xml_doc.elements
    return if elements['/result/error'].present?

    latitude  = elements['/result/coordinate/lat'].text.to_f
    longitude = elements['/result/coordinate/lng'].text.to_f
    { lat: latitude, lon: longitude }
  end

  # Geocoing API を呼び出す
  # 取得できた場合 => REXML::Document
  # 取得できなかった場合 => false
  def geocoding_api
    api_response = call_api_and_handle_error('geocoding')
    api_response && REXML::Document.new(api_response)
  end

  # Current Weather API を呼び出す
  # 取得できた場合 => Hash
  # 取得できなかった場合 => false
  def current_weather_api
    api_response = call_api_and_handle_error('current_weather')
    api_response && JSON.parse(api_response.read, symbolize_names: true)
  end

  # One Call API を呼び出す
  # 取得できた場合 => Hash
  # 取得できなかった場合 => nil
  def one_call_api
    api_response = call_api_and_handle_error('one_call')
    return unless api_response

    json_forecast = JSON.parse(api_response.read, symbolize_names: true)
    refill_rain(json_forecast)
  end

  # 引数に対応する API コールメソッドを呼び出す
  # API コール時にエラーが発生した場合、3回までリトライする
  # 取得できた場合 => APIレスポンス
  # 取得できなかった場合 => false
  def call_api_and_handle_error(api_name)
    retry_count = 0
    begin
      send("call_#{api_name}_api")
    rescue OpenURI::HTTPError => e
      retry_count += 1
      retry_message(e, retry_count)
      retry_count <= RETRY_CALL_API_COUNT ? (sleep RETRY_CALL_API_WAIT_TIME; retry) : false
    end
  end

  def call_geocoding_api
    request_url = "https://www.geocoding.jp/api/?q=#{city}"
    fixed_url   = escape(request_url)

    OpenURI.open_uri(fixed_url)
  end

  def call_current_weather_api
    city_name     = city.slice(/(.+)[市区]/, 1)
    romaji_city   = to_romaji(city_name)
    base_url      = 'http://api.openweathermap.org/data/2.5/weather?lang=ja'
    request_query = "&q=#{romaji_city}"
    app_id        = "&appid=#{Rails.application.credentials.open_weather_api[:app_key]}"

    OpenURI.open_uri(base_url + request_query + app_id)
  end

  def call_one_call_api
    base_url      = 'http://api.openweathermap.org/data/2.5/onecall?lang=ja'
    request_query = "&lat=#{lat}&lon=#{lon}&exclude=current,minutely,daily"
    app_id        = "&appid=#{Rails.application.credentials.open_weather_api[:app_key]}"

    OpenURI.open_uri(base_url + request_query + app_id)
  end

  # OpenWeatherApi の city に対応するローマ字に変換する
  def to_romaji(text)
    kunrei_moji = Zipang.to_slug(text).gsub(/\-/, '').gsub(/m(?!(a|i|u|e|o|m))/, 'n').to_kunrei
    kunrei_moji.gsub(/si/, 'shi').gsub(/ti/, 'chi').gsub(/tu/, 'tsu')
  end

  # OpenWeatherAPI の仕様により、天気が雨以外の場合は雨量が設定されていない
  # 天気が雨であっても、雨量が RAIN_FALL_JUDGMENT [mm] 以下の場合は、曇りとして扱いたい
  # そのため、以下2つの処理を行う
  #  - (1) 天気が雨以外の場合、雨量を 0[mm] に設定
  #  - (2) 雨量が 0 < RAIN_FALL_JUDGMENT [mm] の場合、天気を雨から曇りに変更
  def refill_rain(json_forecast)
    json_forecast[:hourly].each do |hourly|
      hourly[:rain] = { '1h': 0 } if hourly[:rain].nil?
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
      logger.error "[Error] #{exception.class} の再接続に失敗しました。"
      logger.error exception.backtrace
    end
  end
end

class Weather < ApplicationRecord
  include WEBrick::HTTPUtils

  belongs_to :line_user, optional: true

  validates :lat,
            numericality: {
              greater_than_or_equal_to: -90,
              less_than_or_equal_to: 90,
              message: ->(obj, _data) { obj.error_msg[:LAT][:VALIDATE] }
            }

  validates :lon,
            numericality: {
              greater_than_or_equal_to: -180,
              less_than_or_equal_to: 180,
              message: ->(obj, _data) { obj.error_msg[:LON][:VALIDATE] }
            }

  before_validation -> { self.city += '市' },
                    if: [
                      :will_save_change_to_city?,
                      -> { city.present? }
                    ],
                    unless: -> { /.+[市区]/.match(city) }

  def forecast
    @forecast ||= one_call_api
  end

  def geocoding
    @geocoding ||= geocoding_api
  end

  def reset_geocoding(city_name = nil)
    self.city = city_name if city_name

    @geocoding = geocoding_api
  end
  # @return [String] like 'Shibuya'.
  def romaji_city
    return unless city

    city_name = city.gsub(/[市区]/, '')
    to_romaji(city_name).camelize
  end

  def today_is_rainy?
    rain_falls = forecast[:hourly][0...TAKE_WEATHER_HOUR].map { |hourly| hourly[:rain][:'1h'] }
    rain_falls.any? { |rain_fall| rain_fall >= RAIN_FALL_JUDGMENT }
  end

  # validate city can call Geocoding API.
  def city_is_valid?(city_name = nil)
    self.city = city_name if city_name

    geocoding ? true : false
  end

  # save self.city included administrative division.
  def complement_city(city_name = nil)
    self.city = city_name if city_name
    xml_doc   = geocoding
    return unless xml_doc

    location  = xml_doc.elements['/result/google_maps'].text
    self.city = location.slice(/(.+)、.+/, 1)
  end

  # @return [Hash] coord of self.city like { lat: Float, lon: Float }.
  # @return [FalseClass] if failure call Geocoding API.
  def city_to_coord(city_name = nil)
    self.city = city_name if city_name
    xml_doc = geocoding
    return false unless xml_doc

    elements  = xml_doc.elements
    latitude  = elements['/result/coordinate/lat'].text.to_f
    longitude = elements['/result/coordinate/lng'].text.to_f
    { lat: latitude, lon: longitude }
  end

  # update line_user.located_at unless finish location setting.
  # update line_user.locating_from to nil if resetting location.
  def save_location(lat: 0, lon: 0)
    self.lat = lat.round(2)
    self.lon = lon.round(2)
    return unless save

    line_user.update(located_at: Time.zone.now) unless line_user.located_at
    line_user.update(locating_from: nil)        if     line_user.locating_from
    true
  end

  private

  # call Geocoding API.
  # @return [REXML::Document]
  # @return [FalseClass] if failure call Geocoding API.
  def geocoding_api
    sio_response = call_api_and_handle_error('geocoding')
    return false unless sio_response

    xml_doc = REXML::Document.new(sio_response)
    xml_doc.elements['/result/error'].present? ? false : xml_doc
  end

  # call Current Weather API.
  # @return [Hash]
  # @return [FalseClass] if failure call API.
  def current_weather_api
    sio_response = call_api_and_handle_error('current_weather')
    sio_response ? JSON.parse(sio_response.read, symbolize_names: true) : false
  end

  # call One Call API.
  # @return [Hash]
  # @return [FalseClass] if failure call API.
  def one_call_api
    sio_response = call_api_and_handle_error('one_call')
    return false unless sio_response

    json_forecast = JSON.parse(sio_response.read, symbolize_names: true)
    refill_rain(json_forecast)
  end

  # call API method by argument.
  # retry 3times when happened error calling api.
  # @return [StringIO]
  # @return [FalseClass] if failure call API.
  def call_api_and_handle_error(api_name)
    retry_counter = 0
    begin
      send("call_#{api_name}_api")
    rescue OpenURI::HTTPError => e
      retry_counter += 1
      retry_message(e, retry_counter)
      return false if retry_counter > RETRY_CALL_API_COUNT

      (sleep RETRY_CALL_API_WAIT_TIME) && retry
    end
  end

  def retry_message(exception, retry_count)
    if retry_count > RETRY_CALL_API_COUNT
      logger.error error_msg[:CALL_API][:FAILURE][exception]
    else
      logger.error error_msg[:CALL_API][:RETRY][exception, retry_count]
    end
  end

  def call_geocoding_api
    base_uri       = 'https://www.geocoding.jp/api/?'
    request_params = { q: city }

    OpenURI.open_uri(base_uri + request_params.to_query)
  end

  def call_current_weather_api
    city_name      = city.slice(/(.+)[市区]/, 1)
    base_uri       = 'http://api.openweathermap.org/data/2.5/weather?'
    request_params = {
      lang:  'ja',
      q:     to_romaji(city_name),
      appid: Rails.application.credentials.open_weather_api[:app_key]
    }

    OpenURI.open_uri(base_uri + request_params.to_query)
  end

  def call_one_call_api
    base_uri       = 'http://api.openweathermap.org/data/2.5/onecall?'
    request_params = {
      lang:    'ja',
      lat:     lat,
      lon:     lon,
      exclude: 'current,minutely,daily',
      appid:   Rails.application.credentials.open_weather_api[:app_key]
    }

    OpenURI.open_uri(base_uri + request_params.to_query)
  end

  # change city to matched city of OpenWeatherAPI.
  def to_romaji(text)
    kunrei_moji = Zipang.to_slug(text).gsub(/\-/, '').gsub(/m(?!(a|i|u|e|o|m))/, 'n').to_kunrei
    kunrei_moji.gsub(/si/, 'shi').gsub(/ti/, 'chi').gsub(/tu/, 'tsu').gsub(/zyu/, 'ju')
  end

  # OpenWeatherAPI の仕様により、天気が雨以外の場合は雨量が設定されていない
  # 天気が雨であっても、雨量が RAIN_FALL_JUDGMENT [mm] 以下の場合は、曇りとして扱いたい
  # そのため、以下2つの処理を行う
  #  - (1) 天気が雨以外の場合、雨量を 0[mm] に設定
  #  - (2) 雨量が 0 < RAIN_FALL_JUDGMENT [mm] の場合、天気を雨から曇りに変更
  def refill_rain(json_forecast)
    json_forecast[:hourly].each do |hourly|
      hourly[:rain] ||= { '1h': 0 }
      rain_fall = hourly[:rain][:'1h']

      next if rain_fall.zero? || RAIN_FALL_JUDGMENT <= rain_fall

      hourly[:weather].each { |weather| remake_cloudy(weather) }
    end

    json_forecast
  end

  def remake_cloudy(weather)
    weather[:id]          = 804
    weather[:main]        = 'Clouds'
    weather[:description] = 'overcast clouds'
    weather[:icon]        = '04d'
  end
end

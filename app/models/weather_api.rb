class WeatherApi < ApplicationRecord
  belongs_to :user

  validates :lat, numericality: {greater_than_or_equal_to: -45, less_than_or_equal_to: 45}
  validates :lon, numericality: {greater_than_or_equal_to: -180, less_than_or_equal_to: 180}

  def city_varidation
    self.city = to_romaji(city)
    forecast ? self : WeatherApi.new
  end

  def to_romaji(text)
    Zipang.to_slug(text).gsub(/\-/, '').gsub(/m(?!(a|i|u|e|o|m))/, 'n').to_kunrei
  end

  # OpenWeatherAPI から、天気予報を取得
  def forecast
    base_url = 'http://api.openweathermap.org/data/2.5/forecast'

    if (request_query = city.present?)
      request_query = "?cnt=8&q=#{city},jp"
    else
      request_query = "?cnt=8&lat=#{lat}&lon=#{lon}"
    end

    begin
      response = OpenURI.open_uri(base_url + request_query \
                                    + "&appid=#{Rails.application.credentials.open_weather_api[:app_key]}")
      JSON.parse(response.read, symbolize_names: true)
    rescue OpenURI::HTTPError
      false
    end
  end
end

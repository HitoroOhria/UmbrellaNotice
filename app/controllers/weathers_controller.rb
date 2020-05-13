class WeathersController < ApplicationController
  def notice
    @weather_forecast = json_weather_infomation('おしゃまんべ')
    @rain_notice = today_is_rainy?(@weather_forecast)
  end

  private

  # OpenWeatherAPI から、引数の市名の天気予報を取得
  def json_weather_infomation(city_name)
    romaji_city_name = Zipang.to_slug(city_name).gsub(/\-/, '').gsub(/m(?!(a|i|u|e|o|m))/, 'n').to_kunrei
    base_url = 'http://api.openweathermap.org/data/2.5/forecast'
    response = OpenURI.open_uri(base_url + "?cnt=8&q=#{romaji_city_name},jp" \
                                 + "&appid=#{Rails.application.credentials.open_weather_api[:app_key]}")
    JSON.parse(response.read, symbolize_names: true)
  end

  # 引数の天気予報の内容から、雨が降るか判定
  def today_is_rainy?(json_weathers)
    rainy_weathers = json_weathers[:list].select do |weather|
      weather[:rain].present? ? weather[:rain][:'3h'] : nil
    end
    rainy_weathers.find { |weather| weather[:rain][:'3h'] >= 2 } .present?
  end
end

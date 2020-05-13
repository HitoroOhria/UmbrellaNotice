class WeathersController < ApplicationController
  def notice
    # OpenWeatherAPI から、天気予報を取得
    city = Zipang.to_slug('おしゃまんべ').gsub(/\-/, '').to_kunrei.gsub(/m(?!(a|i|u|e|o|m))/, 'n')
    base_url = 'http://api.openweathermap.org/data/2.5/forecast'
    response = open(base_url + "?cnt=8&q=#{city},jp" \
                     + "&appid=#{Rails.application.credentials.open_weather_api[:app_key]}")
    @weather_forecast = JSON.parse(response.read, symbolize_names: true)

    #　取得した天気予報から、雨が降るか判定
    rainy_weathers = @weather_forecast[:list].select do |weather|
      weather[:rain].present? ? weather[:rain][:'3h'] : false
    end
    @rain_notice = rainy_weathers.find { |weather| weather[:rain][:'3h'] >= 2 } .present?
  end
end

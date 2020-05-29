class WeatherApiController < ApplicationController
  def notice
    line_user = LineUser.first
    @weather_forecast = line_user.weather_api.take_forecast
    @rain_notice = today_is_rainy?(@weather_forecast)
  end

  private

  # 引数の天気予報の内容から、雨が降るか判定
  def today_is_rainy?(json_weathers)
    rainy_weathers = json_weathers[:list].select do |weather|
      weather[:rain].present? ? weather[:rain][:'3h'] : nil
    end
    rainy_weathers.find { |weather| weather[:rain][:'3h'] >= 2 } .present?
  end
end

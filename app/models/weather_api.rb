class WeatherApi < ApplicationRecord
  belongs_to :user

  validates :lat, numericality: { greater_than_or_equal_to: -45, less_than_or_equal_to: 45 }
  validates :lon, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  def save_city(event)
    self.city = to_romaji(event.message[:text])
    return unless forecast

    save
    user.line.update_attribute(:located_at, Time.zone.now)
  end

  def save_location(event)
    self.lat = event.message[:latitude]
    self.lon = event.message[:longitude]
    save
    user.line.update_attribute(:located_at, Time.zone.now)
  end

  # OpenWeatherAPI から、天気予報を取得
  def forecast
    retry_count = 0
    begin
      call_weather_api
    rescue OpenURI::HTTPError => e
      retry_count += 1
      retry_message(e, retry_count)
      retry_count <= 3 ? (sleep 5; retry) : false
    end
  end

  private

  def to_romaji(text)
    Zipang.to_slug(text).gsub(/\-/, '').gsub(/m(?!(a|i|u|e|o|m))/, 'n').to_kunrei
  end

  def call_weather_api
    base_url = 'http://api.openweathermap.org/data/2.5/forecast'
    request_query = city ? "?cnt=8&q=#{city},jp" : "?cnt=8&lat=#{lat}&lon=#{lon}"
    response = OpenURI.open_uri(base_url + request_query \
                                  + "&appid=#{Rails.application.credentials.open_weather_api[:app_key]}")
    JSON.parse(response.read, symbolize_names: true)
  end

  def retry_message(exception, retry_count)
    if retry_count <= 3
      puts "#{exception.class} が発生しました。"
      puts '5sec 待機後に再接続します。'
      puts "この処理は3回まで繰り返されます。(現在: #{retry_count}回目)"
    else
      puts "#{exception.class} の再接続に失敗しました。"
    end
  end
end

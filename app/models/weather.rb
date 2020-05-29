class Weather < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :line_user, optional: true

  validates :lat, numericality: { greater_than_or_equal_to: -45, less_than_or_equal_to: 45 },
                  allow_nil: true
  validates :lon, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 },
                  allow_nil: true

  def validate_city(text)
    city_name = text.slice(/(.+)[市区]/, 1) || text
    self.city = to_romaji(city_name)
    take_forecast
  end

  def to_romaji(text)
    Zipang.to_slug(text).gsub(/\-/, '').gsub(/m(?!(a|i|u|e|o|m))/, 'n').to_kunrei
          .gsub(/si/, 'shi').gsub(/ti/, 'chi').gsub(/tu/, 'tsu')
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

  # OpenWeatherAPI から、天気予報を取得
  def take_forecast
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

  def call_weather_api
    base_url = 'http://api.openweathermap.org/data/2.5/forecast'
    request_query = city ? "?cnt=8&q=#{city},jp" : "?cnt=8&lat=#{lat}&lon=#{lon}"
    app_id = "&appid=#{Rails.application.credentials.open_weather_api[:app_key]}"

    response = OpenURI.open_uri(base_url + request_query + app_id)
    JSON.parse(response.read, symbolize_names: true)
  end

  def retry_message(exception, retry_count)
    if retry_count <= 3
      puts "#{exception.class} が発生しました。"
      puts '5sec 待機後に再接続します。'
      puts "この処理は3回まで繰り返されます。(現在: #{retry_count}回目)"
    else
      puts "#{exception.class} の再接続に失敗しました。"
      puts exception.backtrase
    end
  end
end

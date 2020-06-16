module LineMessageHelper
  # '4/1 (月)' のような形式の文字列を返す
  def current_date
    current_time    = Time.zone.now
    current_month   = current_time.month
    current_day     = current_time.day
    day_of_the_week = %w[日 月 火 水 木 金 土][current_time.wday]
    "#{current_month}/#{current_day} (#{day_of_the_week})"
  end

  # OpenWeatherApi の気象条件と対応した絵文字の unicode の Hash
  def emoji
    {
      thunderstorm: "\u{26C8}",
      drizzle:      "\u{1F327}",
      rain:         "\u{2601}",
      snow:         "\u{1F328}",
      atmosphere:   "\u{1F32B}",
      clear:        "\u{2600}",
      clouds:       "\u{2601}"
    }
  end
end

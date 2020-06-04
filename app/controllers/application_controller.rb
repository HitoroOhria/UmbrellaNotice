class ApplicationController < ActionController::Base
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = Rails.application.credentials.line_api[:channel_id]
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token = Rails.application.credentials.line_api[:channel_token]
    }
  end

  # lib/line_messages から、file_name に対応するファイルを読み込む
  def read_message(file_name)
    file_path = Dir[Rails.root + "lib/line_messages/#{file_name}.*"][0]
    case File.extname(file_path)
    when '.txt'
      File.open(file_path).read
    when '.erb'
      ERB.new(File.open(file_path).read).result.gsub(/^\s+/, '')
    end
  end

  # OpenWeatherAPI の weather.main と対応する絵文字の Unicode の Hash
  def emoji
    {
      thunderstorm: '\u{26C8}',
      drizzle:      '\u{1F327}',
      rain:         '\u{2614}',
      snow:         '\u{1F328}',
      atmosphere:   '\u{1F32B}',
      clear:        '\u{2600}',
      clouds:       '\u{2601}'
    }
  end

  def render_success
    render status: 200, json: { status: 200, massage: 'Success Request' }
  end

  def render_bad_request
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end
end

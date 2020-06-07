class ApplicationController < ActionController::Base
  include LineMessageHelper

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id     = Rails.application.credentials.line_api[:channel_id]
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token  = Rails.application.credentials.line_api[:channel_token]
    }
  end

  # lib/line_messages から、file_name に対応するファイルを読み込む
  # locals 変数は、ERB で読み込むファイル内で使用する
  def read_message(file_name, **locals)
    file_path = Dir[Rails.root + "lib/line_messages/#{file_name}.*"][0]

    case File.extname(file_path)
    when '.txt'
      File.open(file_path).read
    when '.erb'
      ERB.new(File.open(file_path).read)
         .result_with_hash(locals: locals, current_date: current_date, emoji: emoji)
         .gsub(/^\s+/, '')
    end
  end

  def render_success
    render status: 200, json: { status: 200, massage: 'Success Request' }
  end

  def render_bad_request
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end
end

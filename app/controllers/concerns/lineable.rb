module Lineable
  extend ActiveSupport::Concern

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id     = Rails.application.credentials.line_api[:channel_id]
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token  = Rails.application.credentials.line_api[:channel_token]
    }
  end

  def reply(token, *file_names, **locals)
    messages = make_messages(file_names, **locals)
    client.reply_message(token, messages)
  end

  def push_message(line_id, *file_names, **locals)
    messages = make_messages(file_names, **locals)
    client.push_message(line_id, messages)
  end

  # LINE返信用のメッセージを作成する
  # @return = [ { type: 'text', text: 'message' }, ... ]
  def make_messages(file_names, **locals)
    messages = file_names.map { |file_name| read_message(file_name, **locals) }
    messages.map { |message| { type: 'text', text: message } }
  end

  # lib/line_messages から、file_name に対応するファイルを読み込む
  # @param file_name = 読み込むファイル名
  #        **lacals  = .erbファイル内で使用されるローカル変数のハッシュ
  def read_message(file_name, **locals)
    file_path = find_by_line_messages(file_name)

    case File.extname(file_path)
    when '.txt'
      File.open(file_path).read
    when '.erb'
      ERB.new(File.open(file_path).read)
         .result_with_hash(current_date: current_date, emoji: emoji, **locals)
         .gsub(/^\s+/, '')
    end
  end

  def find_by_line_messages(file_name)
    messages_dir  = 'lib/line_messages'
    message_types = %w[text rich_menu]
    messages_dirs = message_types.map do |message_type|
      Rails.root + messages_dir + message_type + "#{file_name}.*"
    end

    Dir[*messages_dirs][0]
  end
end

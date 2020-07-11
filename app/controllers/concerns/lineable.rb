module Lineable
  extend ActiveSupport::Concern

  def line_client
    @line_client ||= Line::Bot::Client.new { |config|
      config.channel_id     = credentials.line_api[:message][:channel_id]
      config.channel_secret = credentials.line_api[:message][:channel_secret_id]
      config.channel_token  = credentials.line_api[:message][:channel_token]
    }
  end

  # イベントに対してリプライを送信する
  # @param locals = #read_erb_message で使用するハッシュ { ローカル変数名: オブジェクト, ... }
  def reply(token, *file_names, **locals)
    messages = make_messages(*file_names, **locals)
    line_client.reply_message(token, messages)
  end

  # プッシュメッセージを送信する
  # @param locals = #read_erb_message で使用するハッシュ { ローカル変数名: オブジェクト, ... }
  def push_message(line_id, *file_names, **locals)
    messages = make_messages(*file_names, **locals)
    line_client.push_message(line_id, messages)
  end

  # LINE返信用のメッセージを作成する
  # @return = [ { type: 'text', text: 'message', (quickReply: '...') }, ... ]
  def make_messages(*file_names, **locals)
    messages      = file_names.map  { |file_name| read_message(file_name, **locals) }
    text_messages = messages.select { |message| message.is_a?(String) }
    quick_reply   = messages.select { |message| message.is_a?(Hash) }.last

    if quick_reply
      text_messages.map { |text_message| { type: 'text', text: text_message, quickReply: quick_reply } }
    else
      text_messages.map { |text_message| { type: 'text', text: text_message } }
    end
  end

  # lib/line_messages から、file_name に対応するファイルを読み込む
  # @param file_name = 読み込むファイル名
  def read_message(file_name, **locals)
    file_path = find_by_line_messages(file_name)

    case File.extname(file_path)
    when '.txt'
      read_text_message(file_path)
    when '.erb'
      read_erb_message(file_path, **locals)
    when '.json'
      read_quick_reply(file_path)
    end
  end

  def find_by_line_messages(file_name)
    messages_dir  = 'lib/line_messages'
    message_types = %w[text rich_menu quick_reply]
    messages_dirs = message_types.map do |message_type|
      Rails.root + messages_dir + message_type + "#{file_name}.*"
    end

    Dir[*messages_dirs].last || raise(LoadError, "No such file '#{file_name}'.")
  end

  def read_text_message(file_path)
    File.open(file_path).read
  end

  # LineMessageHelper に依存するため、include すること
  def read_erb_message(file_path, **locals)
    erb_file     = File.open(file_path)
    method_names = LineMessageHelper.public_instance_methods(false)
    variables    = method_names.map { |method_name| [method_name, send(method_name)] }.to_h

    ERB.new(erb_file.read)
       .result_with_hash(**variables, **locals)
       .gsub(/^\s+/, '')
  end

  def read_quick_reply(file_path)
    json_file = File.open(file_path)
    JSON.parse(json_file.read)
  end
end

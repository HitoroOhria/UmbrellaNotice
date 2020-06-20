module Lineable
  extend ActiveSupport::Concern

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id     = credentials.line_api[:message][:channel_id]
      config.channel_secret = credentials.line_api[:message][:channel_secret_id]
      config.channel_token  = credentials.line_api[:message][:channel_token]
    }
  end

  # イベントに対してリプライを送信する
  def reply(token, *file_names, **locals)
    messages = make_messages(*file_names, **locals)
    client.reply_message(token, messages)
  end

  # プッシュメッセージを送信する
  def push_message(line_id, *file_names, **locals)
    messages = make_messages(*file_names, **locals)
    client.push_message(line_id, messages)
  end

  # LINE返信用のメッセージを作成する
  # @return = [ { type: 'text', text: 'message', (quickReply: '...') }, ... ]
  def make_messages(*file_names, **locals)
    messages      = file_names.map { |file_name| read_message(file_name, **locals) }
    text_messages = messages.map   { |hash| hash.try(:[], :text) }.compact
    quick_reply   = messages.find  { |hash| hash.try(:[], :quick_reply) }.try(:[], :quick_reply)

    if quick_reply
      text_messages.map { |text_message| { type: 'text', text: text_message, quickReply: quick_reply } }
    else
      text_messages.map { |text_message| { type: 'text', text: text_message } }
    end
  end

  # lib/line_messages から、file_name に対応するファイルを読み込む
  # @param file_name = 読み込むファイル名
  #        **locals  = .erbファイル内で使用されるローカル変数のハッシュ
  def read_message(file_name, **locals)
    file_path = find_by_line_messages(file_name)

    case File.extname(file_path)
    when '.txt'
      text = read_text_message(file_path)
      { text: text }
    when '.erb'
      text = read_erb_message(file_path, **locals)
      { text: text }
    when '.json'
      hash = read_quick_reply(file_path)
      { quick_reply: hash }
    end
  end

  def find_by_line_messages(file_name)
    messages_dir  = 'lib/line_messages'
    message_types = %w[text rich_menu quick_reply]
    messages_dirs = message_types.map do |message_type|
      Rails.root + messages_dir + message_type + "#{file_name}.*"
    end

    Dir[*messages_dirs][0] || raise(LoadError, "No such file. name: #{file_name}")
  end

  def read_text_message(file_path)
    File.open(file_path).read
  end

  def read_erb_message(file_path, **locals)
    erb_file  = File.open(file_path)
    methods   = %i[new_user_registration_url current_date emoji]
    variables = methods.map { |method| [method, send(method)] }.to_h

    ERB.new(erb_file.read)
       .result_with_hash(**variables, **locals)
       .gsub(/^\s+/, '')
  end

  def read_quick_reply(file_path)
    json_file = File.open(file_path)
    JSON.parse(json_file.read)
  end
end

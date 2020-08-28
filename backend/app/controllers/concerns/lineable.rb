module Lineable
  extend ActiveSupport::Concern

  def line_client
    @line_client ||= Line::Bot::Client.new { |config|
      config.channel_id     = credentials.line_api[:messaging][:channel_id]
      config.channel_secret = credentials.line_api[:messaging][:channel_secret_id]
      config.channel_token  = credentials.line_api[:messaging][:channel_token]
    }
  end

  # イベントに対してリプライを送信する
  def reply(token, *file_names, **locals)
    messages = LineMessageCreator.create_from(*file_names, **locals)
    line_client.reply_message(token, messages)
  end

  # プッシュメッセージを送信する
  def push_message(line_id, *file_names, **locals)
    messages = LineMessageCreator.create_from(*file_names, **locals)
    line_client.push_message(line_id, messages)
  end
end

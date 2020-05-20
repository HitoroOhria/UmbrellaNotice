class LineApiController < ApplicationController
  before_action :validate_signature, :validate_event_type, :validate_source_type, :validate_message_type,
                only: [:webhock]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = Rails.application.credentials.line_api[:channel_id]
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token = Rails.application.credentials.line_api[:channel_token]
    }
  end

  def events
    @events ||= client.parse_events_from(request.body.read)
  end

  def webhock
    events.each do |event|
      user = User.find_or_create_temporary_user(event['source']['userId'])
      if user.line.located_at
        interactive(event)
      else
        locate_setting(event, user)
      end
    end

    render status: 200
  end

  def interactive(event)
    message = { type: 'text', text: 'interacticeです！' }
    client.reply_message(event['replyToken'], message)
    render status: 200
  end

  def locate_setting(event, user)
    weather = user.weather.new
    case event.type
    when Line::Bot::Event::MessageType::Text
      invalid_city unless weather.save_city(event)
    when Line::Bot::Event::MessageType::Location
      weather.save_location(event)
    end

    message = { type: 'text', text: '位置設定が完了しました！' }
    client.reply_message(event['replyToken'], message)
    render status: 200
  end

  def invalid_city
    message = { type: 'text', text: '市名を読み取れませんでした！ひらがなで再送信するか、付近の市名を送信して下さい！' }
    client.reply_message(event['replyToken'], message)
    render status: 200
  end

  private

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return if client.validate_signature(body, signature)

    render json: { status: 400, message: 'Bad Request' }
  end

  def validate_event_type
    events.each do |event|
      next if event.class == Line::Bot::Event::Message

      render status: 400, json: { status: 400, message: 'Not supported EventType' }
    end
  end

  def validate_source_type
    events.each do |event|
      next if event['source']['type'] == 'user'

      message = { type: 'text', text: 'グループトークには対応していません！退出させて下さい！' }
      client.reply_message(event['replyToken'], message)
      render status: 400, json: { status: 400, message: 'Not allowed SourceType' }
    end
  end

  def validate_message_type
    events.each do |event|
      message_type = event['message']['type']
      next if %w[text location].include?(message_type)

      render status: 400, json: { status: 400, message: 'Not supported MessageType' }
    end
  end
end

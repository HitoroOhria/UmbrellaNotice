class LineApiController < ApplicationController
  before_action :validate_signature, :validate_event_type, :validate_source_type, :validate_message_type,
                only: [:webhock]

  protect_from_forgery except: :webhock

  attr_accessor :event

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
    events.each do |item|
      self.event = item
      line_user = LineUser.find_or_create_by(line_id: event['source']['userId'])
      if line_user.located_at
        interactive
      else
        location_setting(line_user)
      end
    end

    render_success
  end

  def interactive
    reply('interacticeです！')
  end

  def location_setting(line_user)
    message = event.message
    content = message['text'] || { lat: message['latitude'], lon: message['longitude'] }
    weather = Weather.new(line_user: line_user)
    case event.type
    when Line::Bot::Event::MessageType::Text
      city_setting(weather, content)
    when Line::Bot::Event::MessageType::Location
      weather.save_location(content[:lat], content[:lon])
    end

    reply('位置設定が完了しました！')
  end

  def city_setting(weather, text)
    if weather.validate_city(text)
      weather.save_city
    else
      reply('市名を読み取れませんでした！ひらがなで再送信するか、付近の市名を送信して下さい！')
    end
  end

  private

  def reply(message)
    client.reply_message(event['replyToken'], { type: 'text', text: message })
  end

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return if client.validate_signature(body, signature)

    render_bad_request('Bad Request')
  end

  def validate_event_type
    events.each do |item|
      self.event = item
      next if event.class == Line::Bot::Event::Message

      render_bad_request('Not supported EventType')
    end
  end

  def validate_source_type
    events.each do |item|
      self.event = item
      next if event['source']['type'] == 'user'

      reply('グループトークには対応していません！退出させて下さい！')
      render_bad_request('Not allowed SourceType')
    end
  end

  def validate_message_type
    events.each do |item|
      self.event = item
      message_type = event['message']['type']
      next if %w[text location].include?(message_type)

      render_bad_request('Not supported MessageType')
    end
  end

  def render_success
    render status: 200, json: { status: 200, massage: 'Success Request' }
  end

  def render_bad_request(message)
    render status: 400, json: { status: 400, message: message }
  end
end

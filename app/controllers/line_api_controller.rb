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
      user = User.find_or_create_temporary_user(event['source']['userId'])
      if user.line.located_at
        interactive
      else
        locate_setting(user)
      end
    end

    render_success
  end

  def interactive
    reply('interacticeです！')
  end

  def locate_setting(user)
    weather = WeatherApi.new(user: user)
    case event.type
    when Line::Bot::Event::MessageType::Text
      invalid_city unless weather.save_city(event)
    when Line::Bot::Event::MessageType::Location
      weather.save_location(event)
    end

    reply('位置設定が完了しました！')
  end

  def invalid_city
    reply('市名を読み取れませんでした！ひらがなで再送信するか、付近の市名を送信して下さい！')
    render_success
    exit
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

class LineApiController < ApplicationController
  before_action :validate_signature, :validate_event_type, :validate_source_type, :validate_message_type,
                only: [:webhock]

  protect_from_forgery except: :webhock

  attr_accessor :event

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

  # 受け取ったイベントから、緯度・経度を保存する
  # 市名を受け取った場合
  #   => Weather#city_is_valid? で有効な市名か検証する
  #   => Weather#save_location で緯度・経度を保存する
  # GPS情報を受け取った場合
  #   => Weather#save_location で緯度・経度を保存する
  def location_setting(line_user)
    message = event.message
    content = message['text'] || { lat: message['latitude'], lon: message['longitude'] }
    weather = Weather.new(line_user: line_user)

    validate_city(weather) if event.type == 'text'
    weather.save_location(content)

    reply(read_message('completed_location_setting'))
  end

  def validate_city(weather)
    weather.city_is_valid?(content) && reply(read_message('invalid_cityname'))
  end

  private

  def reply(message)
    client.reply_message(event['replyToken'], { type: 'text', text: message })
  end

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return if client.validate_signature(body, signature)

    render_bad_request
  end

  def validate_event_type
    events.each do |item|
      self.event = item
      next if event.class == Line::Bot::Event::Message

      render_bad_request
    end
  end

  def validate_source_type
    events.each do |item|
      self.event = item
      next if event['source']['type'] == 'user'

      reply(read_message('invalid_source_type'))
      render_bad_request
    end
  end

  def validate_message_type
    events.each do |item|
      self.event = item
      message_type = event['message']['type']
      next if %w[text location].include?(message_type)

      render_bad_request
    end
  end
end

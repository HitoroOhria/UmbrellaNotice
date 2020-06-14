class LineApiController < ApplicationController
  include RichMenusController

  before_action :validate_signature, :validate_event_type, :validate_source_type, only: [:webhock]

  protect_from_forgery except: :webhock

  attr_accessor :event
  attr_accessor :line_user

  def events
    @events ||= client.parse_events_from(request.body.read)
  end

  def webhock
    events.each do |item|
      initialize_webhock(item)

      if !line_user.located_at || line_user.locating_at
        location_setting
      elsif event.type == 'postback'
        rich_menus
      else
        interactive
      end
    end

    render_success
  end

  def initialize_webhock(item)
    self.event     = item
    self.line_user = LineUser.find_or_create_by(line_id: event['source']['userId'])
  end

  def location_setting
    weather = Weather.find_or_initialize_by(line_user: line_user)
    message = event.message
    content = message['text'] || [message['latitude'], message['longitude']]

    case event.type
    when 'text'
      weather.add_and_save_location(content) || reply('invalid_city_name')
    when 'location'
      weather.save_location(*content)
    end

    reply('completed_location_setting')
  end

  def interactive
    reply('interactive')
  end

  private

  def reply(file_name, **locals)
    message = { type: 'text', text: read_message(file_name, **locals) }
    client.reply_message(event['replyToken'], message)
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
      next if %w[message postback].include?(event.type)

      render_bad_request
    end
  end

  def validate_source_type
    events.each do |item|
      self.event = item
      next if event['source']['type'] == 'user'

      reply('invalid_source_type')
      render_bad_request
    end
  end
end

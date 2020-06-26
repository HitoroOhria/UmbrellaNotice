class LineApiController < ApplicationController
  include RichMenuable

  before_action :validate_signature, :validate_event_type, :validate_source_type, only: [:webhock]

  protect_from_forgery except: :webhock

  attr_accessor :event
  attr_accessor :line_user

  def events
    @events ||= client.parse_events_from(request.body.read)
  end

  def webhock
    events.each do |item|
      self.event     = item
      self.line_user = LineUser.find_or_create_by(line_id: event['source']['userId'])

      control_processing
    end

    render_success
  end

  def control_processing
    if !line_user.located_at || line_user.locating_from
      location_setting
    elsif event.is_a? Line::Bot::Event::Postback
      rich_menus(event, line_user)
    else
      interactive
    end
  end

  def location_setting
    weather = Weather.find_or_initialize_by(line_user: line_user)
    message = event.message
    content = message['text'] || { lat: message['latitude'], lon: message['longitude'] }

    case event.type
    when 'text'
      set_location_form_text(weather, content)
    when 'location'
      weather.save_location(**content)
    end

    weather.persisted? ? reply('completed_location_setting') : reply('invalid_city_name')
  end

  def set_location_form_text(weather, city_name)
    coord = weather.compensate_city(city_name) && weather.city_to_coord
    coord && weather.save_location(**coord)
  end

  def interactive
    reply('interactive')
  end

  private

  def reply(*file_names, **locals)
    token = event['replyToken']
    super(token, *file_names, **locals)
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
      allow_classes = [Line::Bot::Event::Message, Line::Bot::Event::Postback]
      next if allow_classes.include?(event.class)

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

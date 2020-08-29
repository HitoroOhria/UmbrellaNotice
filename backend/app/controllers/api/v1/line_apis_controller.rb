class Api::V1::LineApisController < ApplicationController
  include RichMenuable

  before_action :validate_signature, :validate_event_type, :validate_source_type, only: [:webhock]

  attr_accessor :event, :line_user

  # POST /api/v!/line_api/webhock
  def webhock
    events.each do |item|
      self.event     = item
      self.line_user = LineUser.find_or_create_by(line_id: event['source']['userId'])

      control_event
    end

    render_200('SUCCESS')
  end

  private

  def events
    @events ||= line_client.parse_events_from(request.body.read)
  end

  def control_event
    if !line_user.located_at || line_user.locating_from
      reply_files = %w[finish_location_setting send_location_information]
      corresponding_type? ? location_setting : reply(*reply_files)
    elsif event.is_a?(Line::Bot::Event::Postback)
      rich_menus(event, line_user)
    else
      reply('weather_trivia')
    end
  end

  def corresponding_type?
    corresponding_types = %w[text location]
    event_type          = event.try(:type)

    corresponding_types.include?(event_type)
  end

  def location_setting
    weather = Weather.find_or_initialize_by(line_user: line_user)

    case event.type
    when 'text'
      save_location_form_text(weather) || reply('invalid_city_name', 'send_location_information')
    when 'location'
      save_location_form_coord(weather)
    end

    reply('completed_location_setting')
  end

  def save_location_form_text(weather)
    text = event.message['text']
    weather.compensate_city(text) && (coord = weather.city_to_coord) && weather.save_location(**coord)
  end

  def save_location_form_coord(weather)
    message      = event.message
    coord        = { lat: message['latitude'], lon: message['longitude'] }
    weather.city = nil

    weather.save_location(**coord)
  end

  def reply(*file_names, **locals)
    token = event['replyToken']
    super(token, *file_names, **locals)
  end

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return if line_client.validate_signature(body, signature)

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

class LineApiController < ApplicationController
  before_action :signature_validation, :event_validatin, only: [:webhock]
  # before_action: :request_headers_logging, only: [:webhock]

  def webhock
    event = request_event
    message = event[:message]
    user = User.find_or_create_user_line(event[:source][:user_id])

    case message[:type]
    when 'text'
      weather = user.weather.new(city: message[:text])
      unless weather.city_validation(message[:text]).save
        # 市名が不正な時の処理
      end
    when 'location'
      user.weather.create(lat: message[:latitude], lon: message[:longitude])
    end

    render json: { status: 200, message: 'Request Success' }
  end

  def failure
    render json: { status: 400, message: 'Bad Request' }
  end

  private

  def request_event
    request_json = JSON.parse(request.body.read, symbolize_names: true)
    request_json[:events][0]
  end

  def signature_validation
    channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, channel_secret, http_request_body)
    signature = Base64.strict_encode64(hash)
    x_line_signature = request.headers[:X-Line-Signature]
    failure if signature != x_line_signature
  end

  def event_validation
    failure if request_event[:source][:type] != 'user'
  end

  def request_headers_logging
    request.headers.sort.map { |k, v| logger.info "#{k}:#{v}" }
  end
end

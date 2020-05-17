class LineApiController < ApplicationController
  before_action :validate_signature, only: [:webhock]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = Rails.application.credentials.line_api[:channel_id]
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token = Rails.application.credentials.line_api[:channel_token]
    }
  end

  def webhock
    body = request.body.read
    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        user = User.find_or_create_temporary_user(event[:source][:userId])
        case event.type
        when Line::Bot::Event::MessageType::Text
          weather = user.weather.new(city: event.message[:text])
          unless weather.city_validation(event.message[:text]).save
            message = { type: 'text', text: '市名を読み取れませんでした！ひらがなで再送信するか、付近の市名を送信して下さい！' }
            client.reply_message(event[:replyToken], message)
          end
        when Line::Bot::Event::MessageType::Location
          user.weather.create(lat: event.message[:latitude], lon: event.message[:longitude])
        end
      end
    end

    message = { type: 'text', text: '位置情報の設定に成功しました!' }
    client.reply_message(event[:replyToken], message)

    render status: 200
  end

  private

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    render json: { status: 404, text: 'Bad Request' } unless client.validate_signature(body, signature)
  end
end

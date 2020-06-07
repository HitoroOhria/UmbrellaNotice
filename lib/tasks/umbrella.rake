namespace :umbrella do
  desc 'POST WeathersController#line_notice'
  task line_notice: :environment do
    client ||= Line::Bot::Client.new { |config|
      config.channel_id     = Rails.application.credentials.line_api[:channel_id]
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token  = Rails.application.credentials.line_api[:channel_token]
    }

    line_user  = LineUser.first
    weather    = line_user.weather
    controller = ApplicationController.new
    text       = controller.read_message('notice_weather', line_user: line_user, weather: weather)
    message    = { type: 'text', text: text }

    client.push_message(ENV['LINE_ID'], message)
  end
end

namespace :umbrella do
  desc 'POST WeathersController#line_notice'
  task line_notice: :environment do
    client ||= Line::Bot::Client.new { |config|
      config.channel_id     = Rails.application.credentials.line_api[:messaging][:channel_id]
      config.channel_secret = Rails.application.credentials.line_api[:messaging][:channel_secret_id]
      config.channel_token  = Rails.application.credentials.line_api[:messaging][:channel_token]
    }

    line_user  = LineUser.first
    weather    = line_user.weather
    message    = LineMessageCreator.create_from('notice_weather', line_user: line_user, weather: weather)

    puts client.push_message(ENV['LINE_ID'], message)
  end
end

class Api::V1::WeatherInformationsController < ApplicationController
  before_action :authenticate, only: %i[trigger line_notice]

  # POST /api/v1/weather_information/trigger
  # PARAMS notice_time
  def trigger
    notice_time = current_time_text
    line_users  = LineUser.where(notice_time: notice_time)

    line_users.each do |line_user|
      PostWeathersNoticeWorker.perform_async(line_user.line_id, line_user.auth_token)
    end

    render_200('SUCCESS')
  end

  # POST /api/v1/weather_information/line_notice
  # PARAMS line_id
  def line_notice
    line_user = LineUser.find_by(line_id: params[:line_id])
    weather   = line_user.weather

    push_message(line_user.line_id, 'notice_weather', line_user: line_user, weather: weather)
    render_200('SUCCESS')
  end

  private

  def current_time_text
    current_time = Time.zone.now
    current_hour = current_time.hour.to_s.rjust(2, '0')
    current_min  = current_time.min.to_s.rjust(2, '0')

    "#{current_hour}:#{current_min}"
  end

  def authenticate
    line_user = LineUser.find_by(line_id: params[:line_id])
    token     = line_user.try(:auth_token) || credentials.http[:trigger_token]

    authenticate_or_request_with_http_token do |request_token, _options|
      ActiveSupport::SecurityUtils.secure_compare(request_token, token)
    end
  end
end

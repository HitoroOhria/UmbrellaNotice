class WeathersController < ApplicationController
  before_action :authenticate,         only: %i[trigger line_notice]
  before_action :validate_notice_time, only: [:trigger]

  protect_from_forgery except: %i[trigger line_notice]

  def information
    @weather          = Weather.first
    @weather_forecast = @weather.forecast
  end

  def trigger
    notice_time = current_time_text
    line_users  = LineUser.where(notice_time: notice_time)

    line_users.each do |line_user|
      PostWeathersNoticeWorker.perform_async(line_user.line_id, line_user.auth_token)
    end
    render_success
  end

  def line_notice
    line_user = LineUser.find_by(line_id: params[:line_id])
    weather   = line_user.weather

    push_message(line_user.line_id, 'notice_weather', line_user: line_user, weather: weather)
    render_success
  end

  private

  def current_time_text
    current_time = Time.zone.now
    current_hour = current_time.hour.to_s.rjust(2, '0')
    current_min  = current_time.min.to_s.rjust(2, '0')
    "#{current_hour}:#{current_min}"
  end

  def validate_notice_time
    current_time = Time.zone.now
    notice_time  = params[:notice_time].match(/(\d{2}):(\d{2})/)
    minute_range = (current_time.min - TOLERANCE_TIME)..(current_time.min + TOLERANCE_TIME)
    return if notice_time_is_valid?(current_time, notice_time, minute_range)

    render_bad_request
  end

  def notice_time_is_valid?(current_time, notice_time, minute_range)
    current_time.hour == notice_time[1].to_i || minute_range.include?(notice_time[2].to_i)
  end

  def authenticate
    line_user = LineUser.find_by(line_id: params[:line_id])
    token     = line_user.try(:auth_token) || Rails.application.credentials.http[:trigger_token]

    authenticate_or_request_with_http_token do |request_token, _options|
      ActiveSupport::SecurityUtils.secure_compare(request_token, token)
    end
  end
end

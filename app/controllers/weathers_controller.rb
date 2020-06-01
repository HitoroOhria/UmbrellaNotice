class WeathersController < ApplicationController
  before_action :validate_notice_time, only: [:trigger]
  before_action :authenticate,         only: [:notice]

  RAIN_FALL_JUDGMENT = 2
  TOLERANCE_TIME = 3

  def trigger
    line_users = LineUser.where(notice_time: params[:notice_time])
    line_users.each do |line_user|
      PostNoticeJob.perform_later(line_user.line_id, line_user.token)
    end
    render_success
  end

  def notice
    line_user = LineUser.find_by(line_id: params[:line_id])
    weather_forecast = line_user.weather.take_forecast
    umbrella_notice(line_user.line_id) if today_is_rainy?(weather_forecast)
    render_success
  end

  private

  def today_is_rainy?(json_weathers)
    rain_falls = json_weathers[:list].map do |weather|
      weather[:rain].present? ? weather[:rain][:'3h'] : nil
    end
    rain_falls.compact.find { |rain_fall| rain_fall >= RAIN_FALL_JUDGMENT } .present?
  end

  def umbrella_notice(line_id)
    message = { type: 'text', text: read_message('umbrella_notice') }
    client.push_message(line_id, message)
  end

  def validate_notice_time
    current_time = Time.zone.now
    notice_time = params[:notice_time].match(/(\d{2}):(\d{2})/)
    minute_range = (current_time.min - TOLERANCE_TIME)..(current_time.min + TOLERANCE_TIME)
    return if notice_time_is_valid?(current_time, notice_time, minute_range)

    render_bad_request
  end

  def notice_time_is_valid?(current_time, notice_time, minute_range)
    current_time.hour == notice_time[1].to_i || minute_range.include?(notice_time[2].to_i)
  end

  def authenticate
    line_user = LineUser.find_by(line_id: params[:line_id])
    authenticate_or_request_with_http_token do |token|
      ActiveSupport::SecurityUtils.secure_compare(token, line_user.token)
    end
  end
end

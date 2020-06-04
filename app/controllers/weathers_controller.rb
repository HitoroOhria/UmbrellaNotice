class WeathersController < ApplicationController
  before_action :validate_notice_time, only: [:trigger]
  before_action :authenticate,         only: [:notice]

  protect_from_forgery except: :trigger

  TOLERANCE_TIME = 3

  def information
    weather = Weather.first
    @weather_forecast = weather.take_forecast
  end

  def trigger
    line_users = LineUser.where(notice_time: params[:notice_time])
    line_users.each do |line_user|
      PostWeathersNoticeWorker.perform_async(line_user.line_id, line_user.token)
    end
    render_success
  end

  def line_notice
    line_user = LineUser.find_by(line_id: params[:line_id])
    notice_weather(line_user.line_id) if line_user.weather.today_is_rainy?
    render_success
  end

  private

  def notice_weather(line_id)
    message = { type: 'text', text: read_message('notice_weather') }
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
    token = line_user.try(:token) || Rails.application.credentials.http[:trigger_token]
    authenticate_or_request_with_http_token do |request_token, _options|
      ActiveSupport::SecurityUtils.secure_compare(request_token, token)
    end
  end
end

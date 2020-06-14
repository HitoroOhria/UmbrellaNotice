module RichMenusController
  def rich_menus
    send(event['postback']['data'])
  end

  def reply_weather_forecast
    reply('notice_weather', line_user: line_user, weather: line_user.weather)
  end

  def notice_time_setting
    target_time = event['postback']['params']['time']
    line_user.update_attribute(:notice_time, target_time)
    reply('completed_notice_time_setting')
  end

  def toggle_silent_notice
    boolean = line_user.silent_notice
    line_user.update_attribute(:silent_notice, !boolean)
    reply('completed_toggle_silent_notice')
  end

  def location_resetting
    line_user.locating_at = Time.zone.now
    reply('location_resetting')
  end

  def issue_serial_number
    reply('issue_serial_number', line_user: line_user)
  end

  def profile_page
    redirect_to user_url(line_user.user)
  end
end

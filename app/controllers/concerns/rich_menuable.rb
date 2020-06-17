module RichMenuable
  extend ActiveSupport::Concern

  # Lineリッチメニューのポストバックアクションに対応したメソッドを呼び出す
  # リッチメニューには以下の7つのアクションを設定している
  # send_location 以外のアクションは全てポストバックイベントとして、'post lines/webhock'に送信される
  #   - reply_weather_forecast
  #   - send_location
  #   - notice_time_setting
  #   - toggle_silent_notice
  #   - location_resetting
  #   - issue_serial_number
  #   - profile_page
  def rich_menus(event, line_user)
    send(event['postback']['data'], event, line_user)
  end

  def reply_weather_forecast(_event, line_user)
    reply('notice_weather', line_user: line_user, weather: line_user.weather)
  end

  def notice_time_setting(event, line_user)
    target_time = event['postback']['params']['time']

    line_user.update_attribute(:notice_time, target_time)
    reply('completed_notice_time_setting', line_user: line_user.reload)
  end

  def toggle_silent_notice(_event, line_user)
    boolean = line_user.silent_notice
    line_user.update_attribute(:silent_notice, !boolean)
    reply('completed_toggle_silent_notice', 'description_silent_notice', line_user: line_user)
  end

  def location_resetting(_event, line_user)
    line_user.update_attribute(:locating_from, Time.zone.now)
    reply('location_resetting')
  end

  def issue_serial_number(_event, line_user)
    reply('issue_serial_number', line_user: line_user)
  end

  def profile_page(_event, line_user)
    (user = line_user.user) ? redirect_to(user) : reply('unknown_user')
  end
end

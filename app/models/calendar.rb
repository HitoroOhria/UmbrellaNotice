class Calendar < ApplicationRecord
  belongs_to :user, optional: true

  def authorizer
    scope = Google::Apis::CalendarV3::AUTH_CALENDAR_EVENTS_READONLY
    web = Rails.application.credentials.google_calendar[:recognition][:web].stringify_keys
    client_id = Google::Auth::ClientId.from_hash(Hash['web', web])
    token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
    Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
  end

  def credentials
    authorizer.get_credentials(user_id)
  end

  def authorization_url(base_url)
    authorizer.get_authorization_url(login_hint: user.email, base_url: base_url)
  end

  def service
    @service ||= service_initialize
  end

  def service_initialize
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorizer
    service
  end

  # 直近 TAKE_WEATHER_HOUR 時間のイベントを取得する
  def events
    calendar_id = 'primary'
    service.list_events(calendar_id,
                        max_results:   10,
                        single_events: true,
                        order_by:      'startTime',
                        time_min:      Time.zone.now)
  end

  # 時間をキー、場所を値としたハッシュを返す
  # # @return = { hour(Integer): 'location', ... }
  def plans
    simple_events = events.items.map do |event|
      next if event.location.nil?

      [event.start.date_time, event.end.date_time, event.location]
    end
    to_hourly(simple_events.compact)
  end

  # hourly_plans = [{ hour: Integer, location: 'location' }, ...]
  def to_hourly(simple_events)
    hourly_plans = simple_events.flat_map do |start_time, end_time, location|
      time_range = end_time - start_time

      if time_range < 30.minute.to_i
        hour_time = to_hour(start_time, end_time)
        { hour: hour_time, location: location }
      else
        hour_range = start_time.hour..end_time.hour
        hour_range.to_a.map { |hour| { hour: hour, location: location } }
      end
    end
    make_unique_hour_hash(hourly_plans)
  end

  # 開始時間と終了時間の時計上の範囲によって、対象の時間帯を何時とするか決める
  # 分の範囲が12時の針をまたがない場合 => 開始時間のhourを返す
  # 分の範囲が12時の針をまたぐ場合 => 比率が大きい方のhourを返す
  def to_hour(start_time, end_time)
    start_min  = start_time.min
    start_hour = start_time.hour
    end_min    = end_time.min
    end_hour   = end_time.hour

    if (end_min - start_min).negative?
      end_min < (60 - start_min) ? start_hour : end_hour
    else
      start_hour
    end
  end

  # @return = { hour(Integer): 'location', ... }
  def make_unique_hour_hash(hourly_plans)
    hash_plans = hourly_plans.map { |plan| [plan[:hour], plan[:location]] }.to_h
    hash_plans.uniq { |hour, _location| hour }.to_h
  end
end

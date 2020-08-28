ERROR_MSG = {
  EMBED: {
    VALIDATE: 'only "a-z" or "_" or "." or "*" or ",".'
  },
  USER: {
    ID: {
      NOT_FOUND: ->(id) { "not found user by id: '#{id}'" }
    },
    EMAIL: {
      EXIST:     'Email address already exist.',
      VALIDATE:  'invalid email address.',
      NOT_FOUND: ->(email) { "Not found user by email: '#{email}'." }
    },
    NEW_EMAIL: {
      VALIDATE: 'invalid email address.',
      UPDATE:   'invalid parameter.'
    },
    INHERIT_TOKEN: {
      VALIDATE:  'invalid token length.',
      NOT_FOUND: ->(token) { "Not found line_user by inherit_token: #{token}." }
    },
    ATTRIBUTES: {
      UPDATE_BLANK: ->(array) { "One of #{array} is required." }
    }
  },
  LINE_USER: {
    ID: {
      NOT_FOUND: ->(id) { "not found line_user by id: '#{id}'." }
    },
    NOTICE_TIME: {
      VALIDATE: 'need value like "07:00".'
    },
    SILENT_NOTICE: {
      VALIDATE: 'is "true" or "false".'
    },
    ATTRIBUTES: {
      UPDATE_BLANK: ->(array) { "One of #{array} is required." }
    }
  },
  WEATHER: {
    ID: {
      NOT_FOUND: ->(id) { "not found weather by id: '#{id}'." }
    },
    CITY: {
      NOT_SEARCH: ->(city) { "not search '#{city}' city." }
    },
    LAT: {
      VALIDATE: 'greater than -90 and less than 90.',
      BLANK:    'blank. update coord need "lat" and "lon".'
    },
    LON: {
      VALIDATE: 'greater than -180 and less than 180.',
      BLANK:    'blank. update coord need "lat" and "lon".'
    },
    ATTRIBUTES: {
      UPDATE_BLANK: ->(array) { "One of #{array} is required." }
    },
    CALL_API: {
      RETRY: ->(exception, retry_count) {
        <<-EOS
          [Error] An '#{exception.class}' error has occurred.
          [Error] Wait #{RETRY_CALL_API_WAIT_TIME} seconds and then reconnect.
          [Error] This process will be repeated up to #{RETRY_CALL_API_COUNT} times. (Current: #{retry_count} time)
        EOS
      },
      FAILURE: ->(exception) {
        <<-EOS
          [Error] Failed to reconnect the '#{exception.class}'.
          #{exception.backtrace}
        EOS
      }
    }
  }
}.freeze
ERROR_MSG = {
  EMBED: {
    VALIDATE: 'only "a-z" or "_" or "." or "*" or ",".'
  },
  USER: {
    ID: {
      NOT_FOUND: ->(id) { "not found user by id: '#{id}'" }
    },
    EMAIL: {
      EXIST: 'Email address already exist.',
      VALIDATE: 'invalid email address.',
      NOT_FOUND: ->(email) { "Not found user by email: '#{email}'." }
    },
    NEW_EMAIL: {
      VALIDATE: 'invalid email address.',
      UPDATE: 'invalid parameter.'
    },
    INHERIT_TOKEN: {
      VALIDATE: 'invalid token length.',
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
      VALIDATE: 'need apppvalue like "07:00".'
    },
    SILENT_NOTICE: {
      VALIDATE: 'is "true" or "false".'
    },
    ATTRIBUTES: {
      UPDATE_BLANK: ->(array) { "One of #{array} is required." }
    }
  }
}.freeze
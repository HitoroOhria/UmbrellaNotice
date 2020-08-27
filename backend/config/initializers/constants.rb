# About error message constant -> error_messages.rb

# WeathersController
TOLERANCE_TIME = 3

# User
EMAIL_REGEX = %r{\A[a-zA-Z0-9.!#\z%&'*+/=?\A_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\z}

# Validator
EMBED_REGEX = /([a-z]|_|\.|\*|,)+/

# Weather
RAIN_FALL_JUDGMENT = 0.8
TAKE_WEATHER_HOUR = 15
RETRY_CALL_API_COUNT = 3
RETRY_CALL_API_WAIT_TIME = 5

# Validator
UPDATE_ATTRS = {
  USER:      %w[email],
  LINE_USER: %w[notice_time silent_notice]
}.freeze
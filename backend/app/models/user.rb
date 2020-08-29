class User < ApplicationRecord
  has_one :line_user, dependent: :destroy

  validates :email,
            format: {
              with: EMAIL_REGEX,
              message: ->(obj, _data) { obj.error_msg[:EMAIL][:VALIDATE] }
            }

  def encoded_email
    URI.encode_www_form_component(email)
  end
end

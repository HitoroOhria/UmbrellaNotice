class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable

  has_one :weather_api, dependent: :destroy, class_name: 'WeatherApi'
  has_one :line_api,    dependent: :destroy, class_name: 'LineApi'

  alias_method :weather, :weather_api
  alias_method :line,    :line_api

  def self.find_or_create_temporary_user(line_id)
    line = Line.find_or_create_line(line_id)
    line.user || User.create(email: "#{SecureRandom.alphanumeric}@example.com",
                             password: SecureRandom.base64,
                             line_api: line)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end
end

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable

  belongs_to :weather_api, dependent: :destroy
  belongs_to :line_api,    dependent: :destroy

  alias_method :weather, :weather_api
  alias_method :line, :line_api

  def self.find_or_create_user(line_id)
    Line.find_or_create_line(line_id).user || Line.find_or_create_line(line_id).user.create
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

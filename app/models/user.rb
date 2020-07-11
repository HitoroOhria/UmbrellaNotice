class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable

  has_one :weather
  has_one :calendar, dependent: :destroy

  delegate :line_user, to: :weather, allow_nil: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid      = auth.uid
      user.email    = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name     = auth.info.name
      user.image    = auth.info.image
      user.skip_confirmation!
    end
  end
end

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[facebook]

  has_one :weather
  has_one :calendar, dependent: :destroy

  delegate :line_user, to: :weather, allow_nil: true

  def self.from_line_login(email, line_id)
    user = find_by(email: email)
    return user if user

    user = create_from_api_login(email)
    Calendar.create(user: user) && user.relate_line_user(line_id) && user
  end

  def self.from_omniauth(auth)
    user = find_by(email: auth.info.email)
    return user if user

    user = create_from_api_login(auth.info.email)
    Calendar.create(user: user) && user
  end

  def self.create_from_api_login(email)
    create do |user|
      user.email    = email
      user.password = Devise.friendly_token[0, 20]
      user.skip_confirmation!
    end
  end

  def relate_line_user(line_id)
    line_user = LineUser.find_by(line_id: line_id)
    line_user.weather.update_attribute(:user_id, id)
  end
end

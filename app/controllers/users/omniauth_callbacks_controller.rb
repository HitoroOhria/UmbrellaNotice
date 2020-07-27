# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    callback_from_facebook
  end

  def failure
    redirect_to root_path
  end

  private

  def callback_from_facebook
    user = User.from_omniauth(request.env['omniauth.auth'])
    user.persisted? ? sign_in_by_facebook(user) : failure_by_facebook
  end

  def sign_in_by_facebook(user)
    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
  end

  def failure_by_facebook
    session['devise.facebook_data'] = request.env['omniauth.auth']
    redirect_to new_user_registration_url
  end
end

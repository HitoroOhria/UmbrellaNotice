# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])
    @user.persisted? ? exit_user(@user) : new_user(@user)
  end

  def exit_user(user)
    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
  end

  def new_user(user)
    Calendar.create(user: user)
    session['devise.facebook_data'] = request.env['omniauth.auth']
    redirect_to new_user_registration_url
  end

  def failure
    redirect_to root_path
  end
end

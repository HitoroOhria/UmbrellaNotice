class ApplicationController < ActionController::Base
  include LineMessageHelper
  include Lineable

  def credentials
    Rails.application.credentials
  end

  # サインイン後のリダイレクト先を /users/:id に変更
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def render_success
    render status: 200, json: { status: 200, massage: 'Success Request' }
  end

  def render_bad_request
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end
end

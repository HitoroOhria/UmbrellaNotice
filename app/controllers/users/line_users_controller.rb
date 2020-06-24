class Users::LineUsersController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!

  def new
  end

  def create
    serial_number = params[:serial_number]
    if (line_user = LineUser.find_by(inherit_token: serial_number))
      user         = current_user
      weather      = line_user.weather
      weather.user = user
      weather.save

      redirect_to user_path(user)
      flash[:notice] = 'LINE との連携に成功しました。'
    else
      redirect_to new_users_line_user_path
      flash[:alert] = '無効なシリアル番号です。'
    end
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end

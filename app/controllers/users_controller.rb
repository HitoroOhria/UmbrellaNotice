class UsersController < ApplicationController
  before_action :authenticate_user!

  # /users/:id
  def show
    @user      = current_user
    @calendar  = @user.calendar
    @weather   = @user.weather
    @line_user = @weather.line_user
    @user_id   = session['user_id']
  end
end

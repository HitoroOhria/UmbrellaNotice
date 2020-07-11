class UsersController < ApplicationController
  before_action :authenticate_user!

  # /users/:id
  def show
    @user      = current_user
    @line_user = @user.line_user
    @weather   = @user.weather
    @calendar  = @user.calendar
  end
end

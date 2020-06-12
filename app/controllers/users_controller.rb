class UsersController < ApplicationController
  before_action :authenticate_user!

  # /usres/:id
  def show
    @user    = current_user
    @user_id = session['user_id']
  end
end

class StaticPagesController < ApplicationController
  # root
  def home
    @user = current_user
  end

  # /about
  def about
  end

  # /policy
  def policy
  end

  # /terms
  def terms
  end
end

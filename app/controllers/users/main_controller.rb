class Users::MainController < ApplicationController
  private

  def fetch_user
    User.active.find(params[:user_id])
  end
end
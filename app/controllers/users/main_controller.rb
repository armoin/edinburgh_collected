class Users::MainController < ApplicationController
  private

  def fetch_user
    User.approved.find(params[:user_id])
  end
end
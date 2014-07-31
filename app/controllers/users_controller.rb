class UsersController < ApplicationController
  def new
  end

  def create
    if UserWrapper.create(params[:user])
      redirect_to :login, notice: 'Successfully signed up'
    else
      redirect_to :root, alert: 'Could not sign up new user'
    end
  end
end


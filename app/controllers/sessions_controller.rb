class SessionsController < ApplicationController
  def new
  end

  def create
    token = SessionWrapper.create(params[:username], params[:password])
    session[:auth_token] = token
    if token.present?
      redirect_to :root, notice: 'Successfully logged in'
    else
      redirect_to :login, alert: 'Could not log in'
    end
  end
end


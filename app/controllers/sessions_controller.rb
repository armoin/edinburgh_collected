class SessionsController < ApplicationController
  def new
  end

  def create
    token = SessionWrapper.create(params[:login])
    session[:auth_token] = token
    if token.present?
      redirect_to :root, notice: 'Successfully logged in'
    else
      redirect_to :login, alert: 'Could not log in'
    end
  end

  def destroy
    SessionWrapper.delete(session[:auth_token])
    session.delete(:auth_token)
    redirect_to :root, notice: 'Logged out'
  end
end


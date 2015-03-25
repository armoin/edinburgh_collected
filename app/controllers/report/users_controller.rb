class Report::UsersController < ApplicationController
  include UserAuthenticator

  respond_to :html

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.report!(current_user, user_params[:moderation_reason])
      redirect_to current_memory_index_path, notice: 'Thank you for reporting your concern. We will address it as soon as we can.'
    else
      render :edit
    end
  end

  private

  def user_params
    UserParamCleaner.clean(params)
  end
end

class Report::ScrapbooksController < ApplicationController
  include UserAuthenticator

  respond_to :html

  def edit
    @scrapbook = Scrapbook.find(params[:id])
  end

  def update
    @scrapbook = Scrapbook.find(params[:id])
    if @scrapbook.report!(current_user, scrapbook_params[:moderation_reason])
      redirect_to current_scrapbook_index_path, notice: 'Thank you for reporting your concern.'
    else
      render :edit
    end
  end

  private

  def scrapbook_params
    ScrapbookParamCleaner.clean(params)
  end
end

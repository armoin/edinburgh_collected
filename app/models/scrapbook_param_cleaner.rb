class ScrapbookParamCleaner
  def self.clean(params)
    params.require(:scrapbook).permit(
      :title,
      :description,
    )
  end
end


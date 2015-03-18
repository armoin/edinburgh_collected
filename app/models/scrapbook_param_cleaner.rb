class ScrapbookParamCleaner
  def self.clean(params)
    params.require(:scrapbook).permit(
      :title,
      :description,
      :ordering,
      :deleted,
      :moderation_reason
    )
  end
end


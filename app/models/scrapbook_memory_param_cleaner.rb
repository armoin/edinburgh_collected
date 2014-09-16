class ScrapbookMemoryParamCleaner
  def self.clean(params)
    params.require(:scrapbook_memory).permit(
      :scrapbook_id,
      :memory_id,
    )
  end
end


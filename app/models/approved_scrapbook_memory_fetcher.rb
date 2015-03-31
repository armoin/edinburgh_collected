class ApprovedScrapbookMemoryFetcher < ScrapbookMemoryFetcher
  private

  def scrapbook_memories
    @sm ||= ScrapbookMemory.find_by_sql(ScrapbookMemoryQueryBuilder.new(@scrapbook_ids).approved_query)
  end
end

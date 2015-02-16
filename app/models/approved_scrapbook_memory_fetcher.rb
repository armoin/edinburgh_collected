class ApprovedScrapbookMemoryFetcher < ScrapbookMemoryFetcher
  private

  def scrapbook_memories
    @sm ||= ScrapbookMemory
              .joins(:memory)
              .where(scrapbook_id: @scrapbook_ids, memories: {moderation_state: 'approved'})
              .order('scrapbook_id, ordering')
              .includes(:memory)
  end
end

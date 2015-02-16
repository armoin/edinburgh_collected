class ScrapbookMemoryFetcher
  def initialize(scrapbooks)
    @scrapbook_ids = scrapbooks.map(&:id)
  end

  def scrapbook_memories_for(scrapbook)
    grouped_scrapbook_memories[scrapbook.id] || []
  end

  private

  def grouped_scrapbook_memories
    scrapbook_memories.group_by(&:scrapbook_id)
  end

  def scrapbook_memories
    @sm ||= ScrapbookMemory
              .where(scrapbook_id: @scrapbook_ids)
              .order('scrapbook_id, ordering')
              .includes(:memory)
  end
end

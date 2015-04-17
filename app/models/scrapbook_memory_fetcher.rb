class ScrapbookMemoryFetcher
  def initialize(scrapbooks, user_id=nil)
    @scrapbook_ids = scrapbooks.map(&:id)
    @user_id = user_id
  end

  def scrapbook_memories_for(scrapbook)
    grouped_scrapbook_memories[scrapbook.id] || []
  end

  private

  def grouped_scrapbook_memories
    scrapbook_memories.group_by(&:scrapbook_id)
  end

  def scrapbook_memories
    sql = ScrapbookMemoryQueryBuilder.new(@scrapbook_ids).approved_or_owned_by_query(@user_id)
    @sm ||= ScrapbookMemory.find_by_sql(sql)
  end
end

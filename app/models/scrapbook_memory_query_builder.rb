class ScrapbookMemoryQueryBuilder < ScrapbookQueryBuilder
  def all_query
    base_query scrapbook_memories_table[Arel.star]
  end
end

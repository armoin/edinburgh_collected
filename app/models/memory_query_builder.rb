class MemoryQueryBuilder < ScrapbookQueryBuilder
  def all_query
    base_query memories_table[Arel.star]
  end
end

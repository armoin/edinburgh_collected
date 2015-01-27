class SearchResults
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def memory_results
    @memories ||= Memory.text_search(@query)
  end

  def scrapbook_results
    @scrapbooks ||= Scrapbook.text_search(@query)
  end

  def memory_count
    memory_results.length
  end

  def scrapbook_count
    scrapbook_results.length
  end
end

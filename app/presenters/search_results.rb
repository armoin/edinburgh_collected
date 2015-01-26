class SearchResults
  attr_reader :query

  def initialize(model, query, page)
    @model = model
    @query = query
    @page = page
  end

  def paged_results
    send(@model).page(@page)
  end

  def memory_count
    memories.length
  end

  def scrapbook_count
    scrapbooks.length
  end

  private

  def memories
    @memories ||= Memory.text_search(@query)
  end

  def scrapbooks
    @scrapbooks ||= Scrapbook.text_search(@query)
  end
end


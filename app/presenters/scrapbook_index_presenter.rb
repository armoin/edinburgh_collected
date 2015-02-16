class ScrapbookIndexPresenter
  def initialize(scrapbooks, scrapbook_memory_fetcher, page=nil)
    @scrapbooks = scrapbooks || []
    @scrapbook_memory_fetcher = scrapbook_memory_fetcher
    @page = page
  end

  def scrapbook_covers
    fetch_covers(@scrapbooks)
  end

  def scrapbooks_count
    @scrapbooks.length
  end

  def paginated_scrapbooks
    @scrapbooks.page(@page)
  end

  def paginated_scrapbook_covers
    fetch_covers(paginated_scrapbooks)
  end

  private

  def fetch_covers(scrapbooks)
    scrapbooks.map{|s| ScrapbookCover.new(s, @scrapbook_memory_fetcher.scrapbook_memories_for(s))}
  end
end

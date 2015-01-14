class ScrapbookCover
  def initialize(scrapbook)
    @scrapbook = scrapbook
  end

  def main_memory
    memories.first
  end

  def memory_count
    memories.length
  end

  private

  def memories
    @memories ||= @scrapbook.try(:memories) || []
  end
end


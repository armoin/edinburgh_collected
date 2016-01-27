class ScrapbookCover
  NUM_SECONDARY_MEMORIES = 3

  attr_reader :scrapbook

  def initialize(scrapbook, scrapbook_memories)
    @scrapbook = scrapbook
    @memories = scrapbook_memories.try(:map, &:memory) || []
  end

  def scrapbook_id
    @scrapbook.id
  end

  def title
    @scrapbook.title
  end

  def memories_count
    @memories.length
  end

  def main_memory
    @memories.select(&:photo?).first || @memories.first
  end

  def secondary_memories
    Array.new(NUM_SECONDARY_MEMORIES) {|i| other_memories[i]}
  end

  private

  def other_memories
    @memories - [main_memory]
  end
end

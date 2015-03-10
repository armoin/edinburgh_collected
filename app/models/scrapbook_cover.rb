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
    @memories.first
  end

  def secondary_memories
    Array.new(NUM_SECONDARY_MEMORIES).map.with_index do |memory, i|
      @memories[i+1] # skip the first memory as that is the main memory
    end
  end
end

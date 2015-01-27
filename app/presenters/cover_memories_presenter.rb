class CoverMemoriesPresenter
  NUM_SECONDARY_MEMORIES = 3

  attr_reader :memories

  def initialize(memories)
    @memories = memories
  end

  def main_memory
    @memories.first
  end

  def secondary_memories
    Array.new(NUM_SECONDARY_MEMORIES).map.with_index do |memory, i|
      @memories[i+1] # skip the first memory as that is the main memory
    end
  end

  def memory_count
    @memories.length
  end
end

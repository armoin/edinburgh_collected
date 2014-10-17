class ScrapbookMemory < ActiveRecord::Base
  belongs_to :scrapbook
  belongs_to :memory

  scope :by_ordering, -> { order(:ordering) }

  before_create :assign_ordering

  def self.cover_memory_for(scrapbook)
    where(scrapbook: scrapbook).by_ordering.first.try(:memory)
  end

  private

  def assign_ordering
    self.ordering = self.scrapbook.memories.count
  end
end

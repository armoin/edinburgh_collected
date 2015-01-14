class ScrapbookMemory < ActiveRecord::Base
  belongs_to :scrapbook
  belongs_to :memory

  scope :by_ordering, -> { order(:ordering) }

  before_create :assign_ordering

  def self.reorder_for_scrapbook(scrapbook, ordering)
    ScrapbookMemory.transaction do
      ordering.each.with_index do |id, i|
        sm = ScrapbookMemory.find_by(scrapbook_id: scrapbook.to_param, id: id)
        sm.update!(ordering: i)
      end
    end
  end

  def self.remove_from_scrapbook(scrapbook, deleted)
    ScrapbookMemory.transaction do
      deleted.each do |id|
        sm = ScrapbookMemory.find_by(scrapbook_id: scrapbook.to_param, id: id)
        sm.destroy!
      end
    end
  end

  private

  def assign_ordering
    self.ordering = self.scrapbook.memories.count
  end
end

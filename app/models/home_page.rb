class HomePage < ActiveRecord::Base
  NUM_SCRAPBOOK_MEMORIES = 4

  belongs_to :featured_memory, class: Memory
  belongs_to :featured_scrapbook, class: Scrapbook

  validates :featured_memory, presence: true
  validate :featured_memory_is_visible, if: 'featured_memory_id.present?'

  validates :featured_scrapbook, presence: true
  validate :featured_scrapbook_is_visible, if: 'featured_scrapbook_id.present?'

  validate :has_valid_featured_scrapbook_memory_ids?

  def self.current
    where(published: true).last
  end

  private

  def featured_memory_is_visible
    is_visible?(featured_memory, :featured_memory)
  end

  def featured_scrapbook_is_visible
    is_visible?(featured_scrapbook, :featured_scrapbook)
  end

  def is_visible?(attribute, column_name)
    return true if attribute.publicly_visible?
    errors.add(column_name, 'must be publicly visible')
    false
  end

  def has_valid_featured_scrapbook_memory_ids?
    return true if has_enough_scrapbook_memories?
    errors.add(:base, 'Must have four scrapbook memories picked.')
    false
  end

  def has_enough_scrapbook_memories?
    featured_scrapbook_memory_ids &&
      featured_scrapbook_memory_ids.split(',').size == NUM_SCRAPBOOK_MEMORIES
  end
end

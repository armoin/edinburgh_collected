class HomePage < ActiveRecord::Base
  NUM_SCRAPBOOK_MEMORIES = 4

  belongs_to :featured_memory, class: Memory
  belongs_to :featured_scrapbook, class: Scrapbook

  validates :featured_memory, presence: true
  validate :has_valid_featured_memory?, if: 'featured_memory_id.present?'

  validates :featured_scrapbook, presence: true
  validate :has_valid_featured_scrapbook?, if: 'featured_scrapbook_id.present?'

  validate :has_valid_featured_scrapbook_memory_ids?

  def self.current
    where(published: true).last
  end

  private

  def featured_memory_is_visible?
    is_visible?(featured_memory, :featured_memory)
  end

  def featured_memory_is_photo?
    return true if featured_memory.photo?
    errors.add(:featured_memory, 'must be a photo memory')
  end

  def featured_scrapbook_is_visible?
    is_visible?(featured_scrapbook, :featured_scrapbook)
  end

  def featured_scrapbook_has_enough_picture_memories?
    return true if has_enough_picture_memories?
    errors.add(:featured_scrapbook, "must have at least #{NUM_SCRAPBOOK_MEMORIES} picture memories")
  end

  def is_visible?(attribute, column_name)
    return true if attribute.publicly_visible?
    errors.add(column_name, 'must be publicly visible')
    false
  end

  def has_valid_featured_memory?
    featured_memory_is_visible? && featured_memory_is_photo?
  end

  def has_valid_featured_scrapbook?
    featured_scrapbook_is_visible? && featured_scrapbook_has_enough_picture_memories?
  end

  def has_valid_featured_scrapbook_memory_ids?
    return true if has_enough_scrapbook_memories?
    errors.add(:base, 'Must have four scrapbook memories picked.')
    false
  end

  def has_enough_picture_memories?
    featured_scrapbook.memories.where(type: 'Photo').size >= NUM_SCRAPBOOK_MEMORIES
  end

  def has_enough_scrapbook_memories?
    featured_scrapbook_memory_ids &&
      featured_scrapbook_memory_ids.split(',').size == NUM_SCRAPBOOK_MEMORIES
  end
end

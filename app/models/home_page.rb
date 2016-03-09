class HomePage < ActiveRecord::Base
  REQUIRED_SCRAPBOOK_MEMORIES = 4

  belongs_to :featured_memory, class: Memory
  belongs_to :featured_scrapbook, class: Scrapbook

  validates :featured_memory, presence: true
  validate :featured_memory_is_visible?, if: 'featured_memory_id.present?'
  validate :featured_memory_is_photo?, if: 'featured_memory_id.present?'

  validates :featured_scrapbook, presence: true
  validate :featured_scrapbook_is_visible?, if: 'featured_scrapbook_id.present?'
  validate :featured_scrapbook_has_enough_picture_memories?, if: 'featured_scrapbook_id.present?'

  validate :has_required_number_of_scrapbook_memories?
  validate :all_belong_to_featured_scrapbook?, if: 'featured_scrapbook_id.present?'

  def self.current
    where(published: true).last
  end

  def featured_scrapbook_memories
    featured_scrapbook
      .scrapbook_memories
      .includes(:memory)
      .where(id: featured_ids)
      .map(&:memory)
  end

  private

  def featured_memory_is_visible?
    is_visible?(featured_memory, :featured_memory)
  end

  def featured_memory_is_photo?
    return true if featured_memory.photo?
    errors.add(:featured_memory, 'must be a photo memory')
    false
  end

  def featured_scrapbook_is_visible?
    is_visible?(featured_scrapbook, :featured_scrapbook)
  end

  def featured_scrapbook_has_enough_picture_memories?
    return true if picture_memories.size >= REQUIRED_SCRAPBOOK_MEMORIES

    errors.add(:featured_scrapbook, "must have at least #{REQUIRED_SCRAPBOOK_MEMORIES} picture memories")
    false
  end

  def has_required_number_of_scrapbook_memories?
    return true if featured_ids.size == REQUIRED_SCRAPBOOK_MEMORIES
    errors.add(:base, "Must have #{REQUIRED_SCRAPBOOK_MEMORIES} scrapbook memories picked.")
    false
  end

  def all_belong_to_featured_scrapbook?
    return true if featured_ids.all?{ |id| scrapbook_memory_ids.include?(id) }
    errors.add(:base, 'All scrapbook memories must belong to the featured scrapbook.')
    false
  end

  def is_visible?(attribute, column_name)
    return true if attribute.publicly_visible?
    errors.add(column_name, 'must be publicly visible')
    false
  end

  def featured_ids
    return [] if featured_scrapbook_memory_ids.blank?
    featured_scrapbook_memory_ids.split(',').map(&:to_i)
  end

  def scrapbook_memory_ids
    featured_scrapbook.scrapbook_memories.map(&:id)
  end

  def picture_memories
    featured_scrapbook.memories.where(type: 'Photo')
  end
end

class HomePage < ActiveRecord::Base
  extend CarrierWave::Mount
  mount_uploader :hero_image, HeroImageUploader

  include ImageManipulator

  REQUIRED_SCRAPBOOK_MEMORIES = 4

  before_validation :attach_hero_image

  belongs_to :featured_memory, class_name: Memory
  belongs_to :featured_scrapbook, class_name: Scrapbook

  validates :featured_memory_id, presence: { message: "must be a valid memory ID" }
  validate :featured_memory_is_visible?, if: 'featured_memory_id.present?'
  validate :featured_memory_is_photo?, if: 'featured_memory.present?'

  validates :featured_scrapbook_id, presence: { message: "must be a valid scrapbook ID" }
  validate :featured_scrapbook_is_visible?, if: 'featured_scrapbook_id.present?'
  validate :featured_scrapbook_has_enough_picture_memories?, if: 'featured_scrapbook.present?'

  def self.published
    where(published: true)
  end

  validate :has_required_number_of_scrapbook_memories?
  validate :all_belong_to_featured_scrapbook?, if: 'featured_scrapbook_id.present?'

  def self.current
    published.last
  end

  def featured_scrapbook_memories
    featured_scrapbook
      .scrapbook_memories
      .includes(:memory)
      .where(id: featured_ids)
      .map(&:memory)
  end

  def state
    self.published? ? 'live' : 'draft'
  end

  def publish
    return false unless persisted? && featured_ids.size == REQUIRED_SCRAPBOOK_MEMORIES
    HomePage.published.each {|home_page| home_page.update_column(:published, false) }
    self.update_column(:published, true)
  end

  private

  def featured_memory_is_visible?
    is_visible?(featured_memory, :featured_memory_id)
  end

  def featured_memory_is_photo?
    return true if featured_memory.photo?
    errors.add(:featured_memory_id, 'must be a photo memory')
    false
  end

  def featured_scrapbook_is_visible?
    is_visible?(featured_scrapbook, :featured_scrapbook_id)
  end

  def featured_scrapbook_has_enough_picture_memories?
    return true if picture_memories.size >= REQUIRED_SCRAPBOOK_MEMORIES

    errors.add(:featured_scrapbook_id, "must have at least #{REQUIRED_SCRAPBOOK_MEMORIES} picture memories")
    false
  end

  def has_required_number_of_scrapbook_memories?
    return true if featured_ids.size == REQUIRED_SCRAPBOOK_MEMORIES
    errors.add(:featured_scrapbook_memory_ids, "must have #{REQUIRED_SCRAPBOOK_MEMORIES} scrapbook memories picked.")
    false
  end

  def all_belong_to_featured_scrapbook?
    return true if featured_ids.all?{ |id| scrapbook_memory_ids.include?(id) }
    errors.add(:featured_scrapbook_memory_ids, 'all scrapbook memories must belong to the featured scrapbook.')
    false
  end

  def is_visible?(attribute, column_name)
    return true if attribute.try(:publicly_visible?)
    errors.add(column_name, 'must exist and be publicly visible')
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

  def attach_hero_image
    self.remote_hero_image_url = self.featured_memory.try(:source_url) if self.featured_memory_id_changed?
  end
end

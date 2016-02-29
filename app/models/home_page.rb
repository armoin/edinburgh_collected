class HomePage < ActiveRecord::Base
  belongs_to :featured_memory, class: Memory
  belongs_to :featured_scrapbook, class: Scrapbook

  validates :featured_memory, presence: true
  validate :featured_memory_is_visible, if: 'featured_memory_id.present?'

  validates :featured_scrapbook, presence: true
  validate :featured_scrapbook_is_visible, if: 'featured_scrapbook_id.present?'

  validates :featured_scrapbook_memory_ids, presence: true

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
end

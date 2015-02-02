class Scrapbook < ActiveRecord::Base
  belongs_to :user
  has_many :scrapbook_memories, dependent: :destroy
  has_many :memories, through: :scrapbook_memories

  validates :title, :user, presence: true
  validates :title, length: {maximum: 200}
  validates :description, length: {maximum: 1000}

  SEARCHABLE_FIELDS       = [:title, :description]
  SEARCHABLE_ASSOCIATIONS = {}

  include Searchable

  # TODO: remove this once moderation is in place
  def self.approved
    all
  end

  def cover
    @cover ||= ScrapbookCover.new(self)
  end

  def update(params)
    ordering = params.delete(:ordering)
    deleted = params.delete(:deleted)
    super
    reorder_memories(ordering)
    remove_memories(deleted)
    errors.messages.empty?
  end

  def ordered_memories
    scrapbook_memories.by_ordering.includes(:memory).map(&:memory)
  end

  def approved_ordered_memories
    ordered_memories.select(&:approved?)
  end

  private

  def reorder_memories(ordering_string)
    if ordering_string.present?
      ScrapbookMemory.reorder_for_scrapbook(self, ordering_string.split(','))
    end
  end

  def remove_memories(deleted_string)
    if deleted_string.present?
      ScrapbookMemory.remove_from_scrapbook(self, deleted_string.split(','))
    end
  end
end


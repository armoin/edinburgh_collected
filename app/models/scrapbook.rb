class Scrapbook < ActiveRecord::Base
  belongs_to :user
  has_many :scrapbook_memories, dependent: :destroy
  has_many :memories, through: :scrapbook_memories

  validates :title, :user, presence: true
  validates :title, length: {maximum: 200}
  validates :description, length: {maximum: 1000}

  include Moderatable

  SEARCHABLE_FIELDS       = [:title, :description]
  SEARCHABLE_ASSOCIATIONS = {}

  include Searchable

  scope :by_recent, -> { order('created_at DESC') }

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
    Memory.find_by_sql approved_or_same_owner_query.to_sql
  end

  def approved_ordered_memories
    Memory.find_by_sql approved_query.to_sql
  end

  private

  def approved_or_same_owner_query
    query_builder.approved_or_owned_by_query(self.user_id)
  end

  def approved_query
    query_builder.approved_query
  end

  def query_builder
    MemoryQueryBuilder.new(self.id)
  end

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


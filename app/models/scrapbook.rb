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
    Memory.find_by_sql query(true)
  end

  def approved_ordered_memories
    Memory.find_by_sql query(false)
  end

  private

  def query(include_unapproved)
    memories_table = Memory.arel_table
    scrapbook_memories_table = ScrapbookMemory.arel_table

    query = scrapbook_memories_table
      .project( memories_table[Arel.star] )
      .join( memories_table )
        .on( scrapbook_memories_table[:memory_id].eq(memories_table[:id]) )
      .where( scrapbook_memories_table[:scrapbook_id].eq(self.id) )
      .order( scrapbook_memories_table[:ordering] )

    if include_unapproved
      query.where(
        memories_table[:moderation_state].eq('approved')
          .or( memories_table[:user_id].eq(self.user_id) ) )
    else
      query.where( memories_table[:moderation_state].eq('approved') )
    end
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


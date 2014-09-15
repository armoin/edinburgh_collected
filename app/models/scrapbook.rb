class Scrapbook < ActiveRecord::Base
  belongs_to :user
  has_many :scrapbook_memories
  has_many :memories, through: :scrapbook_memories

  validates :title, :user, presence: true
end


class Category < ActiveRecord::Base
  has_and_belongs_to_many :memories

  validates :name, presence: true
end

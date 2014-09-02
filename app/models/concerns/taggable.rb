module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
  end

  TAG_DELIMITER = ','

  def tag_list
    self.tags.map(&:name).join(', ')
  end

  def tag_list=(tag_names)
    return unless tag_names
    self.tags = tag_names.split(TAG_DELIMITER).map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end
end


module Searchable
  extend ActiveSupport::Concern

  include PgSearch

  included do
    pg_search_scope :search,
      against: self::SEARCHABLE_FIELDS,
      using: {tsearch: {dictionary: "english"}},
      associated_against: self::SEARCHABLE_ASSOCIATIONS,
      ignoring: :accents

    pg_search_scope :by_category,
      using: {tsearch: {dictionary: "english"}},
      associated_against: {categories: :name},
      ignoring: :accents

    # pg_search_scope :by_tag,
    #   using: {tsearch: {dictionary: "english"}},
    #   associated_against: {taggings: :memory_id, tags: :name},
    #   ignoring: :accents
  end

  module ClassMethods
    
    # searches only content that has been approved by a moderator

    def text_search(query)
      return approved unless query.present?
      approved.search(query)
    end

    def filter_by_category(category)
      return approved unless category.present? && reflections.has_key?(:categories)
      approved.by_category(category)
    end

    # def filter_by_tag(tag)
    #   return approved unless tag.present? && reflections.has_key?(:tags)
    #   p tag: tag
    #   result = approved.by_tag(tag)
    #   p result: result
    #   result
    # end
  end
end


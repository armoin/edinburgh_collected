module Searchable
  extend ActiveSupport::Concern

  include PgSearch

  included do
    pg_search_scope :search,
      against: self::SEARCHABLE_FIELDS,
      using: {tsearch: {dictionary: "english"}},
      associated_against: self::SEARCHABLE_ASSOCIATIONS,
      ignoring: :accents
  end

  module ClassMethods
    def text_search(query)
      return all unless query.present?
      all.search(query)
    end
  end
end


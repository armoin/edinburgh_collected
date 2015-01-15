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
    # searches only content that has been approved by a moderator
    def text_search(query)
      return approved unless query.present?
      approved.search(query)
    end
  end
end


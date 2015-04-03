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
    # searches only content that is publicly visible (see moderatable.rb)
    def text_search(query)
      return publicly_visible unless query.present?
      publicly_visible.search(query)
    end
  end
end


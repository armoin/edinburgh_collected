class Memory < ActiveRecord::Base
  include Locatable
  include Taggable
  include Moderatable

  SEARCHABLE_FIELDS       = [:title, :description, :year, :location]
  SEARCHABLE_ASSOCIATIONS = {categories: :name, tags: :name, area: :name}

  include Searchable

  belongs_to :user
  belongs_to :area
  has_and_belongs_to_many :categories
  has_many :scrapbook_memories, dependent: :destroy
  has_many :scrapbooks, through: :scrapbook_memories

  def self.file_types
    %w(Photo Written)
  end

  validates_presence_of :title, :description, :user, :type
  validates :year, numericality: {
                     only_integer: true,
                     greater_than: 0,
                     message: 'is not a valid year',
                     unless: Proc.new { |memory| memory.year.blank? }
                   },
                   format: { with: /\d{4}/, message: 'must be in the format YYYY', allow_blank: true }
  validates_presence_of :categories, message: 'must have at least one'
  validates :type, inclusion: { in: Memory.file_types, message: "must be of type 'photo'", judge: :ignore }
  validate :date_not_in_future
  validates_length_of :title, :attribution, maximum: 200
  validates_length_of :description, maximum: 1500

  scope :by_last_created, -> { order('created_at DESC') }

  def self.filter_by_area(area)
    return publicly_visible unless area.present?
    publicly_visible.joins(:area).where('areas.name' => area)
  end

  def self.filter_by_category(category)
    return publicly_visible unless category.present?
    publicly_visible.joins(:categories).where('categories.name' => category)
  end

  def date
    Date.new(self.year.to_i, the_month, the_day)
  end

  def date_string
    return year unless month.present?
    return month_string unless day.present?
    day_string
  end

  def category_list
    categories.map(&:name).join(', ')
  end

  def photo?
    self.type == 'Photo'
  end

  private

  def date_not_in_future
    if self.date > Time.now
      errors.add(:base, "The date can't be in the future")
    end
  end

  def the_month
    return 1 if self.month.blank?
    self.month.to_i
  end

  def the_day
    return 1 if self.day.blank?
    self.day.to_i
  end

  def month_string
    Time.new(year, month).strftime('%B %Y')
  end

  def day_string
    day_ord = ActiveSupport::Inflector.ordinalize(day.to_i)
    Time.new(year, month).strftime("#{day_ord} %B %Y")
  end
end

require 'carrierwave/mount'

class Memory < ActiveRecord::Base
  extend CarrierWave::Mount
  include Locatable
  include Taggable
  include Moderatable

  SEARCHABLE_FIELDS       = [:title, :description, :year, :location]
  SEARCHABLE_ASSOCIATIONS = {categories: :name}

  include Searchable

  belongs_to :user
  belongs_to :area
  has_and_belongs_to_many :categories
  has_many :scrapbook_memories, dependent: :destroy
  has_many :scrapbooks, through: :scrapbook_memories
  has_many :memory_moderations

  attr_accessor :rotation

  def self.file_types
    ["Photo"]
  end

  def self.moderation_record
    MemoryModeration
  end

  validates_presence_of :title, :description, :source, :user, :year, :type
  validates_presence_of :categories, message: 'must have at least one'
  validates :type, inclusion: { in: Memory.file_types }
  validate :date_not_in_future

  scope :by_recent, -> { order('created_at DESC') }

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

  def moderation_records
    memory_moderations
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

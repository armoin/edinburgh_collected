require 'carrierwave/mount'

class Memory < ActiveRecord::Base
  extend CarrierWave::Mount
  include Locatable
  include Taggable

  belongs_to :user
  belongs_to :area
  has_and_belongs_to_many :categories
  has_many :scrapbook_memories, dependent: :destroy
  has_many :scrapbooks, through: :scrapbook_memories

  attr_accessor :rotation

  MAX_YEAR_RANGE = 120

  scope :by_recent, -> { order('created_at DESC') }

  def self.file_types
    ["Photo"]
  end

  def self.furthest_year
    current_year - MAX_YEAR_RANGE
  end

  def self.current_year
    Time.now.year
  end

  validates_presence_of :title, :source, :user, :year
  validates_presence_of :categories, message: 'must have at least one'
  validates :year,
            inclusion: { in: (furthest_year..current_year).map(&:to_s), message: 'must be within the last 120 years.' },
            if: :year_changed?
  validates :type, inclusion: { in: Memory.file_types }

  def date
    return year unless month.present?
    return month_string unless day.present?
    day_string
  end

  def category_list
    categories.map(&:name).join(', ')
  end

  private

  def month_string
    Time.new(year, month).strftime('%B %Y')
  end

  def day_string
    day_ord = ActiveSupport::Inflector.ordinalize(day.to_i)
    Time.new(year, month).strftime("#{day_ord} %B %Y")
  end
end

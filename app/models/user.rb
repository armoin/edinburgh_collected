class User < ActiveRecord::Base
  extend CarrierWave::Mount
  mount_uploader :avatar, AvatarUploader

  include ImageManipulator
  include Moderatable

  authenticates_with_sorcery!

  PASSWORD_LENGTH = 6

  has_many :memories, dependent: :destroy
  has_many :scrapbooks, dependent: :destroy
  has_many :links, dependent: :destroy

  attr_accessor :password, :password_confirmation

  before_validation :downcase_email
  before_update :send_activation, if: :email_changed?

  validates :first_name, presence: true
  validates :last_name, presence: true, unless: Proc.new { |u| u.is_group? }
  validates :screen_name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, email: true
  validates :password, length: { minimum: PASSWORD_LENGTH }, confirmation: true, if: :password_changed?
  validates :accepted_t_and_c, presence: { message: 'must be accepted' }

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  alias :user_id :id

  # Email is downcased before validating so always check for downcased email
  def self.find_by_email(email)
    where('LOWER(email) = ?', email.downcase).first
  end

  def self.active
    where(activation_state: 'active')
  end

  def name
    [first_name, last_name].join(' ').strip
  end

  def can_modify?(object)
    return false unless object
    object.try(:user_id) == self.id || self.is_admin?
  end

  def active?
    activation_state == 'active'
  end

  def pending?
    activation_state == 'pending' && activation_token.present?
  end

  def is_starting?
    !(has_memories? && has_scrapbooks? && has_profile?)
  end

  def has_memories?
    memories.any?
  end

  def has_scrapbooks?
    scrapbooks.any?
  end

  def has_profile?
    avatar.present? || description.present? || links.any?
  end

  def access_denied?
    blocked?
  end

  def access_denied_reason
    'Your account has been blocked. Please contact us if you would like more information.'
  end

  private

  def downcase_email
    self.email = self.email.try(:downcase)
  end

  def password_changed?
    self.crypted_password.blank? ||
      (self.password.present? || self.password_confirmation.present?)
  end

  def send_activation
    send(:setup_activation)
    send(:send_activation_needed_email!)
  end
end

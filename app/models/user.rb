class User < ActiveRecord::Base
  extend CarrierWave::Mount
  mount_uploader :avatar, AvatarUploader

  authenticates_with_sorcery!

  PASSWORD_LENGTH = 6

  has_many :memories, dependent: :destroy
  has_many :scrapbooks, dependent: :destroy
  has_many :links, dependent: :destroy

  attr_accessor :password, :password_confirmation, :image_angle, :image_scale, :image_w, :image_h, :image_x, :image_y

  before_validation :downcase_email
  before_update :send_activation, if: :email_changed?

  validates :first_name, presence: true
  validates :last_name, presence: true, unless: Proc.new { |u| u.is_group? }
  validates :screen_name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, email: true
  validates :password, length: { minimum: PASSWORD_LENGTH }, confirmation: true, if: :password_changed?
  validates :accepted_t_and_c, presence: { message: 'must be accepted' }

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  # Email is downcased before validating so always check for downcased email
  def self.find_by_email(email)
    where('LOWER(email) = ?', email.downcase).first
  end

  def self.active
    where(activation_state: 'active')
  end

  def can_modify?(object)
    return false unless object
    object.try(:user_id) == self.id || self.is_admin?
  end

  def image_modified?
    rotated? || scaled? || cropped?
  end

  def rotated?
    present_and_non_zero?(self.image_angle)
  end

  def scaled?
    present_and_positive?(self.image_scale)
  end

  def cropped?
    present_and_positive?(self.image_w) && present_and_positive?(self.image_h)
  end

  def process_image
    return true unless image_modified?

    self.updated_at = Time.now
    self.avatar.recreate_versions! unless no_image? || new_image_uploaded?
    self.save
  end

  private

  def no_image?
    self.avatar.blank?
  end

  def new_image_uploaded?
    self.previous_changes.has_key?(:avatar)
  end

  def present_and_positive?(value)
    value.present? && value.to_f > 0
  end

  def present_and_non_zero?(value)
    value.present? && value.to_f != 0
  end

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

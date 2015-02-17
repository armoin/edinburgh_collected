class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :memories, dependent: :destroy
  has_many :scrapbooks, dependent: :destroy

  attr_accessor :password, :password_confirmation

  before_validation :downcase_email
  before_update :send_activation, if: :email_changed?

  validates :first_name, presence: true
  validates :last_name, presence: true, unless: Proc.new { |u| u.is_group? }
  validates :screen_name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, email: true
  validates :password, length: { minimum: 3 }, confirmation: true, if: :password_changed?
  validates :accepted_t_and_c, presence: { message: 'must be accepted' }

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

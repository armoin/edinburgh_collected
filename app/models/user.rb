class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :memories
  has_many :scrapbooks

  attr_accessor :password, :password_confirmation

  before_validation :downcase_email
  before_update :send_activation, if: :email_changed?

  validates :first_name, presence: true
  validates :screen_name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, email: true
  validates :password, length: { minimum: 3 }, confirmation: true, if: :password_changed?

  # Email is downcased before validating so always check for downcased email
  def self.find_by_email(email)
    where('LOWER(email) = ?', email.downcase).first
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

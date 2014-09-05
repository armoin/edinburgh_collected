class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :memories

  attr_accessor :password, :password_confirmation

  validates :first_name, presence: true
  validates :screen_name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, email: true
  validates :password, length: { minimum: 3 }, confirmation: true, if: :password_changed?

  private

  def password_changed?
    self.crypted_password.blank? ||
      (self.password.present? || self.password_confirmation.present?)
  end
end

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :memories

  attr_accessor :password, :password_confirmation

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true, presence: true, email: true
  validates :password, length: { minimum: 3 }, confirmation: true
  validates :password_confirmation, presence: true

  def screen_name
    read_attribute(:screen_name) || self.first_name
  end
end

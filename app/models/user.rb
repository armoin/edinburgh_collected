class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :password, :password_confirmation

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 3 }, confirmation: true
  validates :password_confirmation, presence: true
end

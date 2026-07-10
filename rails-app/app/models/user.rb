class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Core mandatory validation parameters
  validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :date_of_birth, presence: true

  # FIXED: Added strict mandatory email validation requirements
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Restricts password length checking to account creation only, unblocking logins!
  validates :password, presence: true, length: { minimum: 8 }, on: :create
end
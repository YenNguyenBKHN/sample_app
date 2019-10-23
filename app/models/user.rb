class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email_validate_regex
  before_save{self.email = email.downcase}

  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :email, presence: true, length: {maximum: Settings.max_email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :password, presence: true, length: {minimum: Settings.min_pass}

  has_secure_password
end

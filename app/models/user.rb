class User < ApplicationRecord
  
  before_create do
    self.token_created_at = Time.current
  end

  has_secure_password
  has_secure_token

  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: true

  validates :password, length: { minimum: 6 }, if: :password_digest_changed?

  validates :name, presence: true

  def invalidate_token
    update(token: nil, token_created_at: nil)
  end

  def update_token
    regenerate_token
    update(token_created_at: Time.current)
  end

  def self.valid_login?(email, password)
    user = find_by(email: email)
    user if user&.authenticate(password)
  end

end

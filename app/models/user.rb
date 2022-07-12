class User < ApplicationRecord
  
  before_create do
    self.token_created_at = Time.current
  end

  after_create do
    create_user_type
  end

  has_secure_password
  has_secure_token

  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: true

  validates :password, length: { minimum: 6 }, if: :password_digest_changed?

  validates :name, presence: true
  validates :user_type, presence: true, inclusion: { in: %w(landlord homeseeker),
                                    message: "is not a valid user type" }

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

  def create_user_type
    if self.user_type == "landlord"
      landlord = Landlord.new(user_id: self.id)
      landlord.save
    else
      homeseeker = Homeseeker.new(user_id: self.id)
      homeseeker.save
    end
  end

end

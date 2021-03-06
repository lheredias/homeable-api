class Saved < ApplicationRecord
  belongs_to :homeseeker
  belongs_to :property
  # validates :property, presence: true
  validates :homeseeker, uniqueness: { scope: :property }
  validate :valid_property

  def valid_property
    errors.add(:property, "is invalid") unless Property.exists?(self.property_id)
  end

end

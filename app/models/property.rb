class Property < ApplicationRecord
  belongs_to :landlord

  validates :address, presence: true
  validates :about, presence: true
  validates :price, numericality: { grater_than: 0 }

  validates :operation, presence: true, inclusion: { in: %w(sale rent),
    message: "is not a valid operation" }
  enum operation: { rent: 0, sale: 1 }

  enum property_type: { apartment: 0, house: 1 }
  validates :property_type, presence: true, inclusion: { in: %w(apartment house brownfield greenfield),
    message: "is not a valid type of property" }

  validates :bedrooms, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :bathrooms, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_many :photos
  paginates_per 8

  validates :maintenance, presence: true, numericality: { greater_than: 0 }, if: proc { rent? }

  # validates :maintenance, presence: true, if: proc { self.operation == "rent" }

  # validate :maintenance_validator

  # def maintenance_validator
  #   errors.add(:maintenance, "is invalid") unless Property.exists?(self.property_id)
  # end

  # has_one_attached :photo
end

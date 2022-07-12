class Property < ApplicationRecord
  belongs_to :landlord
  belongs_to :saved

  validates :operation, presence: true, inclusion: { in: %w(sale rent),
    message: "is not a valid operation" }

  validates :adress, presence: true
  validates :salpriceary, numericality: { grater_than: 0 }
  validates :user_type, presence: true, inclusion: { in: %w(landlord homeseeker),
    message: "is not a valid user type" }

end

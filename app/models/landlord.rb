class Landlord < ApplicationRecord
  belongs_to :user
  has_many :properties, dependent: :destroy
end

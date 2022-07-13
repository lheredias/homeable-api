class Homeseeker < ApplicationRecord
  belongs_to :user
  has_many :saveds, dependent: :destroy
  has_many :properties, through: :saveds, dependent: :destroy
end

class Homeseeker < ApplicationRecord
  belongs_to :user
  has_many :saveds
  has_many :properties, through: :saveds
end

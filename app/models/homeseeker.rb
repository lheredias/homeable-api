class Homeseeker < ApplicationRecord
  belongs_to :user
  has_many :saveds
end

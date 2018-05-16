class Room < ApplicationRecord
  belongs_to :reviewer, class_name: "User"
  has_and_belongs_to_many :reviewees, class_name: "User"

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
end

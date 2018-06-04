# == Schema Information
#
# Table name: review_requests
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)
#  description :text(65535)
#  is_open     :boolean          default(TRUE), not null
#  state       :integer          default("wait_review"), not null
#  pull_id     :integer
#  reviewee_id :integer
#  room_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ReviewRequest < ApplicationRecord
  extend Enumerize

  belongs_to :pull, inverse_of: :review_requests
  belongs_to :reviewee, class_name: "User", inverse_of: :review_requests
  belongs_to :room, inverse_of: :review_assigns
  has_many :review_comments, dependent: :destroy, inverse_of: :review_request

  validates :name, presence: true, length: { maximum: 1000 }
  validates :description, length: { maximum: 10000 }
  validates :is_open, inclusion: { in: [true, false] }
  validates :state, presence: true
  validates :pull_id, presence: true
  validates :reviewee_id, presence: true
  validates :room_id, presence: true

  enumerize :state, in: { wait_review: 0, change_request: 1, approved: 2 }
end

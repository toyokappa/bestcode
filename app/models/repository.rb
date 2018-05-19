class Repository < ApplicationRecord
  belongs_to :user, inverse_of: :repositories

  URL_FORMAT = /\A#{URI::regexp(%w(http https))}\z/i
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :url, presence: true, format: { with: URL_FORMAT, message: "には「http://」もしくは「https://」から始まるURLを入力してください" }
  validates :is_privarte, presence: true
  validates :is_visible, presence: true
end

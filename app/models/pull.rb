# == Schema Information
#
# Table name: pulls
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)
#  description :text(65535)
#  url         :string(255)
#  number      :integer
#  is_open     :boolean          default(FALSE), not null
#  repo_id     :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Pull < ApplicationRecord
  belongs_to :repo, inverse_of: :pulls
  has_many :review_requests, dependent: :destroy, inverse_of: :pull

  # NOTE: ユーザーが後ほど変更できうる値にバリデーションを掛ける
  validates :name, presence: true, length: { maximum: 200 }
  validates :description, length: { maximum: 10000 }
  validates :is_open, inclusion: { in: [true, false] }

  scope :with_hooked_repos, -> { includes(:repo).where(is_open: true, repos: { is_hook: true }) }

  def sync!(github_pull)
    github_pull_state = github_pull.state == "open"
    update!(
      name: github_pull.title,
      description: github_pull.body,
      url: github_pull.html_url,
      is_open: github_pull_state,
    )
  end
end

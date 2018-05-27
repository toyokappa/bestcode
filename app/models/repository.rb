class Repository < ApplicationRecord
  belongs_to :user, inverse_of: :repositories
  has_many :pull_requests, dependent: :destroy, inverse_of: :repository

  # NOTE: ユーザーが後ほど変更できうる値にバリデーションを掛ける
  validates :description, length: { maximum: 10000 }
  validates :is_visible, inclusion: { in: [true, false] }

  def sync!(github_repo)
    update!(
      name: github_repo.name,
      full_name: github_repo.full_name,
      description: github_repo.description,
      url: github_repo.html_url,
      is_private: github_repo.private,
      pushed_at: github_repo.pushed_at,
    )

    # リポジトリの閲覧範囲が変わった場合のみ、閲覧可否を変更する
    update!(is_visible: !is_private) if is_private_changed?
  end

  def create_pull_request!(github_pull)
    github_pull_state = github_pull.state == "open"
    pull_requests.create!(
      id: github_pull.id,
      name: github_pull.title,
      description: github_pull.body,
      url: github_pull.html_url,
      number: github_pull.number,
      is_open: github_pull_state,
      created_at: github_pull.created_at,
      updated_at: github_pull.updated_at,
    )
  end
end

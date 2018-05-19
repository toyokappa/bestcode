class Repository < ApplicationRecord
  belongs_to :user, inverse_of: :repositories

  URL_FORMAT = /\A#{URI::regexp(%w(http https))}\z/i
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :url, presence: true, format: { with: URL_FORMAT, message: "には「http://」もしくは「https://」から始まるURLを入力してください" }
  validates :is_privarte, inclusion: { in: [true, false] }
  validates :is_visible, inclusion: { in: [true, false] }

  def sync!(github_repo)
    update!(
      name: github_repo.full_name,
      description: github_repo.description,
      url: github_repo.html_url,
      is_privarte: github_repo.private,
      pushed_at: github_repo.pushed_at,
      updated_at: github_repo.updated_at,
    )

    # リポジトリの閲覧範囲が変わった場合のみ、閲覧可否を変更する
    update!(is_visible: !is_privarte) if is_privarte_changed?
  end
end

# == Schema Information
#
# Table name: users
#
#  id           :bigint(8)        not null, primary key
#  provider     :string(255)
#  uid          :string(255)
#  name         :string(255)
#  email        :string(255)
#  contribution :integer          default(0), not null
#  is_reviewer  :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  access_token :string(255)
#

class User < ApplicationRecord
  has_many :owned_rooms, class_name: "Room", foreign_key: "reviewer_id", dependent: :destroy, inverse_of: :reviewer
  has_many :participations, foreign_key: "reviewee_id", dependent: :destroy, inverse_of: :reviewee
  has_many :participating_rooms, class_name: "Room", through: :participations
  has_many :reviewees, through: :owned_rooms
  has_many :reviewers, through: :participating_rooms
  has_many :repos, dependent: :destroy, inverse_of: :user
  has_many :pulls, through: :repos
  has_many :review_requests, foreign_key: "reviewee_id", dependent: :destroy, inverse_of: :reviewee
  has_many :review_assigns, class_name: "ReviewRequest", through: :owned_rooms
  has_many :review_comments, dependent: :destroy, inverse_of: :user

  mount_uploader :image, ImageUploader

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  after_create :init_repos_and_pulls

  def participatable?(room)
    !own?(room) && !participating?(room) && !room.over_capacity?
  end

  def participating?(room)
    participating_rooms.include?(room)
  end

  def create_repo!(github_repo)
    repos.create!(
      id: github_repo.id,
      name: github_repo.name,
      full_name: github_repo.full_name,
      description: github_repo.description,
      url: github_repo.html_url,
      is_private: github_repo.private,
      is_visible: !github_repo.private,
      pushed_at: github_repo.pushed_at,
      created_at: github_repo.created_at,
      updated_at: github_repo.updated_at,
    )
  end

  def own?(room)
    self == room.reviewer
  end

  def get_visible_review_reqs_from(review_reqs)
    self.review_requests & review_reqs
  end

  def check_and_return_image(type = nil)
    if image.present?
      type == :thumb ? image.thumb.url : image.url
    else
      "/images/no_user.png"
    end
  end

  class << self
    def create_with_omniauth(auth)
      contribution = total_contribution(auth.info.nickname)
      create!(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.nickname,
        email: auth.info.email,
        remote_image_url: auth.info.image,
        contribution: contribution,
        is_reviewer: reviewable_with?(contribution),
        access_token: auth.credentials.token,
      )
    end

    def get_contribution(nickname)
      # NOTE: できればこの処理を自鯖に持ちたいので修正する
      url = "https://github-contributions-api.now.sh/v1/#{nickname}"
      uri = URI.parse url
      request = Net::HTTP::Get.new(uri.request_uri)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end
      body = JSON.parse response.body
      body["years"]
    end

    # 昨年〜今年のコントリビューションを取得し合算
    def total_contribution(nickname)
      yearly_contributions = get_contribution(nickname)
      yearly_contributions[0]["total"]
    end

    def reviewable_with?(contribution)
      contribution >= 1000
    end
  end

  private

    def init_repos_and_pulls
      SyncReposAndPullsJob.perform_later(self)
    end
end

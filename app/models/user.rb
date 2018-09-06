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
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  access_token :string(255)
#

class User < ApplicationRecord
  extend Enumerize
  include User::Firestore

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
  has_many :evaluations, foreign_key: "reviewee_id", dependent: :destroy, inverse_of: :reviewee

  enumerize :role, in: [:reviewee, :reviewer], predicates: true

  mount_uploader :image, UserImageUploader
  mount_uploader :header_image, HeaderImageUploader

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  after_create :init_repos

  def participatable?(room)
    !own?(room) && !participating?(room) && !room.over_capacity?
  end

  def join(room)
    self.participating_rooms << room
    join_firestore_chat(room)
  end

  def own?(room)
    self == room.reviewer
  end

  def participating?(room)
    participating_rooms.include?(room)
  end

  def belonging_to?(room)
    own?(room) || participating?(room)
  end

  def evaluated?(room)
    evaluations.find_by(room: room).present?
  end

  def evaluations_score(output = nil, round = nil)
    length = owned_rooms.sum {|room| room.evaluations.length }
    return output if length.zero?

    total = owned_rooms.sum(&:evaluations_score)
    score = total / length
    round ? score.round(round) : score
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

  def get_visible_review_reqs_from(review_reqs)
    self.review_requests & review_reqs
  end

  def check_and_return_image(type = nil)
    return "/images/no_user.png" if image.blank?

    type ? image.send(type).url : image.url
  end

  def check_and_return_header_image(type = nil)
    return "/images/no_bg.jpg" if header_image.blank?

    type ? header_image.send(type).url : header_image.url
  end

  def active_state_count_for_reviewer
    review_assigns.where(state: :wait_review, is_open: true).count
  end

  def active_state_count_for_reviewee
    active_state = %i[commented changes_requested approved]
    review_requests.where(state: active_state, is_open: true).count
  end

  def my_repos
    repos.where(is_hook: true)
  end

  def chat_id
    "user_#{id}"
  end

  class << self
    def create_with_omniauth(auth)
      contribution = total_contributions(auth.info.nickname)
      create!(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.nickname,
        email: auth.info.email,
        remote_image_url: auth.info.image,
        contribution: contribution,
        role: which_role_with?(contribution),
        access_token: auth.credentials.token,
      )
    end

    def get_contributions(nickname)
      # NOTE: できればこの処理を自鯖に持ちたいので修正する
      url = "https://github-contributions-api.now.sh"
      conn = Faraday.new url: url do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end

      response = conn.get "/v1/#{nickname}"
      body = JSON.parse response.body
      body["contributions"]
    end

    # コントリビューションの総計を算出
    def total_contributions(nickname)
      contributions = get_contributions(nickname)
      contributions.sum {|con| con["count"] }
    end

    def which_role_with?(contribution)
      (contribution >= 1000) ? :reviewer : :reviewee
    end
  end

  private

    def init_repos
      SyncReposJob.perform_later(self)
    end
end

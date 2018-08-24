class SyncReposJob < ApplicationJob
  queue_as :default

  def perform(user)
    github_user = Octokit::Client.new(access_token: user.access_token, per_page: 100)
    github_user.login
    github_user.repos({}, query: { type: "owner" }).each do |github_repo|
      repo = user.repos.find_by(id: github_repo.id)
      repo ? repo.sync!(github_repo) : user.create_repo!(github_repo)
    end
  end
end

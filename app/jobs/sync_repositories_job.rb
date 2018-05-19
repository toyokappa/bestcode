class SyncRepositoriesJob < ApplicationJob
  queue_as :default

  def perform(user)
    github_user = Octokit::Client.new(access_token: user.access_token, per_page: 100)
    github_user.login
    github_user.repos({}, query: { type: "owner" }).each do |github_repo|
      if repo = user.repositories.find_by(id: github_repo.id)
        repo.sync!(github_repo)
      else
        user.create_repository!(github_repo)
      end
    end
  end
end

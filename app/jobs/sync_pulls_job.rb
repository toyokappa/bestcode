class SyncPullsJob < ApplicationJob
  queue_as :default

  def perform(user, repo)
    github_user = Octokit::Client.new(access_token: user.access_token, per_page: 100)
    github_user.login
    repo.sync!(github_user.repo(repo.id))

    github_user.pulls(repo.id, state: "all").each do |github_pull|
      next if github_pull.blank?

      pull = repo.pulls.find_by(id: github_pull.id)
      if pull
        pull.sync!(github_pull)
      else
        repo.create_pull!(github_pull)
      end
    end
  end
end

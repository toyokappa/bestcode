class SyncPullRequestsJob < ApplicationJob
  queue_as :default

  def perform(user, repo)
    github_user = Octokit::Client.new(access_token: user.access_token, per_page: 100)
    github_user.login

    github_user.pulls(repo.id, state: "all").each do |github_pull|
      next if github_pull.blank?
      if pull = repo.pull_requests.find_by(id: github_pull.id)
        pull.sync!(github_pull)
      else
        repo.create_pull_request!(github_pull)
      end
    end
  end
end

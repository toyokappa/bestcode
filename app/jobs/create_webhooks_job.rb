class CreateWebhooksJob < ApplicationJob
  queue_as :default

  def perform(user, repo)
    github_user = Octokit::Client.new(access_token: user.access_token)
    github_user.login
    github_user.create_hook(
      repo.id,
      "web",
      {
        url: "http://325c6cde.ngrok.io/hooks/pulls",
        content_type: :json,
        secret: "development",
      },
      {
        events: %w[push pull_request],
        active: true,
      },
    )

    repo.update!(is_hook: true)
  end
end

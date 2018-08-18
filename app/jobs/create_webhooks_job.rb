class CreateWebhooksJob < ApplicationJob
  queue_as :default

  def perform(user, repo)
    github_user = Octokit::Client.new(access_token: user.access_token)
    github_user.login
    github_user.create_hook(
      repo.id,
      "web",
      {
        url: Rails.configuration.x.webhook.url,
        content_type: :json,
        secret: Rails.configuration.x.webhook.secret,
      },
      {
        events: %w[push pull_request],
        active: true,
      },
    )

    repo.update!(is_hook: true)
  end
end

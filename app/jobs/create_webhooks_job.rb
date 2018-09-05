class CreateWebhooksJob < ApplicationJob
  queue_as :default

  def perform(user, repo)
    github_user = Octokit::Client.new(access_token: user.access_token)
    github_user.login
    github_user.create_hook(
      repo.id,
      "web",
      {
        url: Rails.configuration.x.webhook.pulls_url,
        content_type: :json,
        secret: Rails.configuration.x.webhook.secret,
      },
      {
        events: %w[push pull_request],
        active: true,
      },
    )
    github_user.create_hook(
      repo.id,
      "web",
      {
        url: Rails.configuration.x.webhook.state_url,
        content_type: :json,
        secret: Rails.configuration.x.webhook.secret,
      },
      {
        events: %w[pull_request_review],
        active: true,
      },
    )

    repo.update!(is_hook: true)
  end
end

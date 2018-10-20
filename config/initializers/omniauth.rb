Rails.application.config.middleware.use OmniAuth::Builder do
  scope = "user, repo:status, admin:repo_hook"
  provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"], scope: scope
end

Rails.application.config.middleware.use OmniAuth::Builder do
  scope = "read:user, user:email, repo:status, admin:repo_hook"
  provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"], scope: scope
end

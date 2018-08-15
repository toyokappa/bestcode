sidekiq_url = "redis://#{Rails.configuration.x.redis_url}"
sidekiq_namespace = "bestcode_#{ENV["RAILS_ENV"]}_sidekiq"

Sidekiq.configure_server do |config|
  config.redis = { url: sidekiq_url, namespace: sidekiq_namespace }
end

Sidekiq.configure_client do |config|
  config.redis = { url: sidekiq_url, namespace: sidekiq_namespace }
end

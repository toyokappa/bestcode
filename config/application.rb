require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Reviewhub
  class Application < Rails::Application
    config.load_defaults 5.2

    config.active_record.default_timezone = :local
    config.time_zone = "Tokyo"
  end
end

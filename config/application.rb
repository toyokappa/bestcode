require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Reviewhub
  class Application < Rails::Application
    config.load_defaults 5.2

    config.generators do |g|
      g.stylesheet false
      g.javascript false
      g.helper false
      g.template_engine = :haml
      g.test_framework :rspec, view_specs: false, helper_specs: false, controller_specs: false
    end

    config.active_record.default_timezone = :local
    config.time_zone = "Tokyo"
  end
end

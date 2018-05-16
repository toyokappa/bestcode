require_relative "boot"

require "rails/all"
require "net/http"

Bundler.require(*Rails.groups)

module Reviewhub
  class Application < Rails::Application
    config.load_defaults 5.2

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.template_engine = :haml
      g.test_framework :rspec, view_specs: false, helper_specs: false, controller_specs: false
    end

    config.active_record.default_timezone = :local
    config.time_zone = "Tokyo"
  end
end

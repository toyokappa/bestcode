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
    config.active_job.queue_adapter = :sidekiq

    # フォームのバリデーションでレイアウトが崩れる問題の対処
    # 参考: https://qiita.com/shunhikita/items/6ddc2cbdae698b514525
    config.action_view.field_error_proc = proc {|html_tag, _instance| html_tag.to_s }
  end
end

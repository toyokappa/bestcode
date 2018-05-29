source "https://rubygems.org"
git_source(:github) {|repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

# Core
gem "bootsnap", ">= 1.1.0", require: false
gem "haml-rails"
gem "mysql2", ">= 0.4.4", "< 0.6.0"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.0"
gem "uglifier", ">= 1.3.0"

# Javascript
gem "coffee-rails", "~> 4.2"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "turbolinks", "~> 5"

# Stylesheet
gem "bootstrap"
gem "sass-rails", "~> 5.0"

# I18n
gem "rails-i18n"

# Authentication
gem "octokit"
gem "omniauth"
gem "omniauth-github"

# Models
gem "enumerize"

# Views
gem "simple_form"
gem "redcarpet"
gem "coderay"

# ActiveJob
gem "redis-namespace"
gem "sidekiq"

group :development, :test do
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "pry-doc"
  gem "pry-rails"
  gem "pry-stack_explorer"
  gem "rspec-rails"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "onkcop", require: false
  gem "rubocop", require: false
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15", "< 4.0"
  gem "chromedriver-helper"
  gem "database_cleaner"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

source "https://rubygems.org"
git_source(:github) {|repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

# Core
gem "bootsnap", ">= 1.1.0", require: false
gem "faraday"
gem "haml-rails"
gem "mysql2", ">= 0.4.4", "< 0.6.0"
gem "puma", "~> 3.11"
gem "puma_worker_killer"
gem "rails", "~> 5.2.0"
gem "uglifier", ">= 1.3.0"

# Javascript
gem "gon"
gem "jbuilder", "~> 2.5"

# I18n
gem "rails-i18n"

# Authentication
gem "jwt"
gem "octokit"
gem "omniauth"
gem "omniauth-github"

# Models
gem "enumerize"
gem "google-cloud-firestore"
gem "seed-fu"

# Views
gem "coderay"
gem "redcarpet"
gem "simple_form"

# ActiveJob
gem "redis-namespace"
gem "sidekiq"

# Uploaders
gem "carrierwave"
gem "fog-aws"
gem "mini_magick"

# Mailer
gem "mailgun_rails"

# Error Tracking
gem "rollbar"

group :development, :test do
  gem "factory_bot_rails"
  gem "letter_opener"
  gem "letter_opener_web"
  gem "pry-byebug"
  gem "pry-doc"
  gem "pry-rails"
  gem "pry-stack_explorer"
  gem "rspec-rails"
end

group :development do
  gem "annotate"
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

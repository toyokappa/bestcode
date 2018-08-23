#!/bin/bash
set -ex

export DISABLE_SPRING=1

echo Start bundle install
bundle install --path=vendor/bundle --clean
RAILS_ENV=${RAILS_ENV} bundle exec sidekiq -q default -q mailers

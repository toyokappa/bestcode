#!/bin/bash
set -ex

echo Start bundle install
RAILS_ENV=${RAILS_ENV} bundle exec rails db:create
RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate
RAILS_ENV=${RAILS_ENV} bundle exec rails db:seed_fu
RAILS_ENV=${RAILS_ENV} bundle exec rails server

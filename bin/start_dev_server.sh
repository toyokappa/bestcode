#!/bin/bash
set -ex

echo Start bundle install
bundle install --path=vendor/bundle --clean

if [ "${MANUAL}" = "" ]; then
  RAILS_ENV=${RAILS_ENV} bundle exec rails db:create
  RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate
  RAILS_ENV=${RAILS_ENV} bundle exec rails db:seed_fu
  rm -f tmp/pids/server.pid
  RAILS_ENV=${RAILS_ENV} bundle exec rails server -b 0.0.0.0
else
  echo "******* MANUAL MODE *******"
  echo start the server with the following command.
  echo "# start rails server"
  echo "rails server -b 0.0.0.0"
  echo "***************************"
  tail -f < /dev/null
fi

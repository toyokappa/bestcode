#!/bin/bash
set -ex

RAILS_ENV=${RAILS_ENV} bundle exec sidekiq

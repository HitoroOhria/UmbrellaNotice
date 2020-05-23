#!/bin/sh

bundle exec rails db:create RAILS_ENV=production
bundle exec rails db:migrate RAILS_ENV=production
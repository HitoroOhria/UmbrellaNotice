#!/bin/sh

bundle exec rails assets:precompile RAILS_ENV=production
bundle exec unicorn_rails -c /umbrellanotice/config/unicorn.rb -E production
#!/bin/sh

bundle exec sidekiq
bundle exec unicorn_rails -c /umbrellanotice/config/unicorn.rb -E production
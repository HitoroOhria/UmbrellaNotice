#!/bin/sh

bundle exec rails db:migrate RAILS_ENV=production
echo Finish production DB migration
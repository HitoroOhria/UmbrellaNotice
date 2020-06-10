source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails',  '~> 5.2.0'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'unicorn'
gem 'unicorn-worker-killer'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks',   '~> 5'
gem 'jbuilder',     '~> 2.5'
gem 'bootsnap',     '>= 1.1.0', require: false
gem 'bootstrap',    '~> 4.5.0'
gem 'jquery-rails'
gem 'devise'
gem 'omniauth-facebook'
gem 'rjb'
gem 'zipang'
gem 'romkan'
gem 'sidekiq'
gem 'redis-namespace'
gem 'aws-sdk-s3'
gem 'line-bot-api'
gem 'google-api-client', '~> 0.34'

group :development, :test do
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-remote'
  gem 'pry-byebug'
  gem 'rails-erd'
  gem 'brakeman'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', require: false
end

group :test do
  gem 'rspec-rails'
  gem 'rspec-sidekiq'
  gem 'spring-commands-rspec'
  gem 'factory_bot_rails'
  gem 'capybara'
  gem 'webdrivers'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

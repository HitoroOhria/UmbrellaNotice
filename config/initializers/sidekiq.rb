Sidekiq.configure_server do |config|
  config.redis = {path: (Rails.root + 'tmp/sockets/redis.sock').to_s}
end

Sidekiq.configure_client do |config|
  config.redis = {path: (Rails.root + 'tmp/sockets/redis.sock').to_s}
end
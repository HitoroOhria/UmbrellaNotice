pro_redis_setting = { host: ENV['REDIS_CACHE_HOST'], port: ENV['REDIS_CACHE_PORT'], namespace: 'sidekiq' }
dev_redis_setting = { path: (Rails.root + 'tmp/sockets/redis.sock').to_s, namespace: 'sidekiq' }

Sidekiq.configure_server do |config|
  if Rails.env.production?
    config.redis = pro_redis_setting
  else
    config.redis = dev_redis_setting
  end
end

Sidekiq.configure_client do |config|
  if Rails.env.production?
    config.redis = pro_redis_setting
  else
    config.redis = dev_redis_setting
  end
end
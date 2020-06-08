pro_redis_setting = { path: (Rails.root + 'tmp/sockets/host/redis.sock').to_s }
dev_redis_setting = { path: (Rails.root + 'tmp/sockets/redis.sock').to_s }

Sidekiq.configure_server do |config|
  case Rails.env
  when 'production'
    config.redis = pro_redis_setting
  else
    config.redis = dev_redis_setting
  end
end

Sidekiq.configure_client do |config|
  case Rails.env
  when 'production'
    config.redis = pro_redis_setting
  else
    config.redis = dev_redis_setting
  end
end
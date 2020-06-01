Sidekiq.configure_server do |config|
  case Rails.env
  when 'production'
    config.redis = {url: 'redis://www.umbrellanotice.work:6379', namespace: 'sidekiq'}
  else
    config.redis = {url: 'redis://redis:6379', namespace: 'sidekiq'}
  end
end

Sidekiq.configure_client do |config|
  case Rails.env
  when 'production'
    config.redis = {url: 'redis://www.umbrellanotice.work:6379', namespace: 'sidekiq'}
  else
    config.redis = {url: 'redis://redis:6379', namespace: 'sidekiq'}
  end
end
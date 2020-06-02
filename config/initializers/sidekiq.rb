Sidekiq.configure_server do |config|
  case Rails.env
  when 'production'
    case ENV['OPT_HOGE']
    when 'timeout'
      config.redis = {url: ENV['HOGEHOGE'], namespace: 'sidekiq', timeout: 5}
    when 'network_timeout'
      config.redis = {url: ENV['HOGEHOGE'], namespace: 'sidekiq', network_timeout: 5, timeout: 5}
    else
      config.redis = {url: ENV['HOGEHOGE'], namespace: 'sidekiq'}
    end
  else
    config.redis = {url: 'redis://redis:6379', namespace: 'sidekiq', network_timeout: 5, timeout: 5}
  end
end

Sidekiq.configure_client do |config|
  case Rails.env
  when 'production'
    case ENV['OPT_HOGE']
    when 'timeout'
      config.redis = {url: ENV['HOGEHOGE'], namespace: 'sidekiq', timeout: 5}
    when 'network_timeout'
      config.redis = {url: ENV['HOGEHOGE'], namespace: 'sidekiq', network_timeout: 5, timeout: 5}
    else
      config.redis = {url: ENV['HOGEHOGE'], namespace: 'sidekiq'}
    end
  else
    config.redis = {url: 'redis://redis:6379', namespace: 'sidekiq', network_timeout: 5, timeout: 5}
  end
end
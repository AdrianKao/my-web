Sidekiq.configure_server do |config|
  # 这里的配置应与你之前单例中的 redis_config 保持一致
  config.redis = {
    url: ENV.fetch("REDIS_URL") { "redis://123456@redis:6379/0" },
    driver: :hiredis # 强制 Sidekiq Server 也使用高性能 C 驱动
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL") { "redis://123456@redis:6379/0" },
    driver: :hiredis
  }
end

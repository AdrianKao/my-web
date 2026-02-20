module Util
  class RedisClient
    # 类级别的实例变量
    class << self
      # 获取Redis客户端实例
      # @return [Redis] Redis客户端实例
      def client
        @client ||= create_client
      rescue StandardError => e
        Rails.logger.error("Redis连接失败: #{e.message}")
        nil
      end

      # 创建Redis客户端实例
      # @return [Redis] Redis客户端实例
      def create_client
        Redis.new(redis_config)
      end

      # 获取Redis配置
      # 配置注释：
      # - url: Redis服务器URL，默认值为'redis://redis:6379/0'
      # - connect_timeout: 连接超时时间，默认值为5秒
      # - read_timeout: 读取超时时间，默认值为3秒
      # - write_timeout: 写入超时时间，默认值为3秒
      # - reconnect_attempts: 重新连接尝试次数，默认值为3次
      # @return [Hash] Redis配置
      def redis_config
        config = {
          url: redis_url,
          connect_timeout: 5,
          read_timeout: 3,
          write_timeout: 3,
          reconnect_attempts: 3
        }
        config
      end

      # 获取Redis URL
      # @return [String] Redis URL
      def redis_url
        ENV.fetch("REDIS_URL", "redis://123456@redis:6379/0")
      end

      # 检查Redis连接是否健康
      # @return [Boolean] 连接是否健康
      def healthy?
        client.ping == "PONG"
      rescue StandardError
        false
      end

      # 设置键值对
      # @param key [String] 键
      # @param value [String, Hash, Array] 值
      # @param expiration [Integer] 过期时间（秒）
      # @return [Boolean] 是否成功
      def set(key, value, expiration = nil)
        if expiration
          client.set(key, value.to_json, ex: expiration)
        else
          client.set(key, value.to_json)
        end
      rescue StandardError => e
        Rails.logger.error("Redis set操作失败: #{e.message}")
        false
      end

      # 获取值
      # @param key [String] 键
      # @return [Object, nil] 值
      def get(key)
        value = client.get(key)
        JSON.parse(value) if value
      rescue StandardError => e
        Rails.logger.error("Redis get操作失败: #{e.message}")
        nil
      end

      # 删除键
      # @param key [String] 键
      # @return [Boolean] 是否成功
      def del(key)
        client.del(key) > 0
      rescue StandardError => e
        Rails.logger.error("Redis del操作失败: #{e.message}")
        false
      end

      # 清除所有实例变量，用于测试或重置连接
      def reset
        @client = nil
      end
    end
  end
end

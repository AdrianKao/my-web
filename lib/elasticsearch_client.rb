# lib/elasticsearch_client.rb
require "elasticsearch"
require "singleton"
require "logger"

class ElasticsearchClient
  include Singleton

  attr_reader :client

  def initialize
    @client = build_client
  end

  # 核心：对外暴露 client 方法
  def self.client
    instance.client
  end

  # 方便直接代理常用方法（可选，链式调用更优雅）
  def self.search(*args, &block)
    client.search(*args, &block)
  end

  def self.index(*args, &block)
    client.index(*args, &block)
  end

  def self.bulk(*args, &block)
    client.bulk(*args, &block)
  end

  # ... 可按需代理其他常用方法：count, delete, update, scroll, etc.

  private

  def build_client
    hosts = determine_hosts
    log   = Rails.env.development? || Rails.env.test?

    Elasticsearch::Client.new(
      hosts:           hosts,
      log:             log,                    # 开发环境打印详细日志
      logger:          es_query_logger,        # 自定义日志记录器
      tracer:          es_query_logger,        # 添加 tracer 配置，记录 DSL
      reload_connections: true,               # 自动重连（集群场景很有用）
      retry_on_failure:   3,                  # 失败重试次数
      request_timeout:    30,                 # 单次请求超时（秒）
      # adapter:            :net_http_persistent,  # 推荐使用持久连接（性能更好）
      adapter:            :net_http,
      enable_compatibility_mode: true

      # compression:      true,               # 如果 ES 支持 gzip，可开启
      # ssl: { ... }                          # 如果是 https + 自签证书场景
      # transport_options: { request: { timeout: 60 } }
    )
  end

  def es_query_logger
    @es_query_logger ||= begin
      log_file = Rails.root.join("log", "es_query.log")
      logger = Logger.new(log_file)
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime.strftime('%Y-%m-%d %H:%M:%S.%L')} #{severity} #{msg}\n"
      end
      logger.level = Logger::INFO
      logger
    end
  end

  def determine_hosts
    # 优先级：环境变量 > credentials > 硬编码 fallback
    if url = ENV["ELASTICSEARCH_URL"] || Rails.application.credentials.elasticsearch&.url
      return [ url ]
    end

    # 支持多节点（逗号分隔）
    if hosts = ENV["ELASTICSEARCH_HOSTS"]
      return hosts.split(",").map(&:strip)
    end

    # 默认本地开发
    if Rails.env.development? || Rails.env.test?
      return [ "http://elk:9200" ]
    end

    # 生产环境请务必通过 ENV 或 credentials 配置！
    raise "Elasticsearch hosts not configured in production!" if Rails.env.production?

    [ "http://elk:9200" ] # fallback
  end
end

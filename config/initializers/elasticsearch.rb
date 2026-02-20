# config/initializers/elasticsearch.rb
require Rails.root.join("lib/elasticsearch_client.rb")

# 预热（可选，确保启动时就创建连接）
ElasticsearchClient.instance

# 可选：给 ActiveSupport::LogSubscriber 等加日志标签
# 注意：elasticsearch 8.x 版本的客户端结构已改变，不再直接支持这种方式
# 如需添加日志标签，请使用自定义日志记录器的方式

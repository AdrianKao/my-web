# app/models/concerns/searchable.rb
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # 设置自定义客户端（可选，如果你之前定义了 ElasticsearchClient）
    __elasticsearch__.client = ElasticsearchClient.instance.client if defined?(ElasticsearchClient)
  end

  class_methods do
    # 提供一个统一的入口来配置 ES
    def configure_elasticsearch(&block)
      # 默认设置
      es_settings = {
        number_of_shards: 1,
        number_of_replicas: 0
      }

      # 这里的 self 是引用该 Concern 的 Model 类
      settings index: es_settings do
        mappings dynamic: "strict", &block
      end
    end
  end
end

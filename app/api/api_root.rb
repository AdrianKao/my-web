  class ApiRoot < Grape::API
    format :json
    prefix :api # 访问路径前缀，例如 /api/v1/...
    helpers ::Helpers::ResponseHelper
    # test claude
    rescue_from :all do |e|
      Rails.logger.error "API Error: #{e.message},API Path: #{env['PATH_INFO']},Backtrace: #{e.backtrace[0..10]}"
      error!({ error: "\u670D\u52A1\u5668\u5185\u90E8\u9519\u8BEF" }, 500)
    end

    mount ::V1::Base # 挂载具体的业务逻辑
  end

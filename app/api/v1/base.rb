module V1
  class Base < Grape::API
    version "v1", using: :path # 路径中包含版本号

    helpers ::Helpers::AuthHelper

    before do
      # 登录和注册不检查权限
      if env["PATH_INFO"] !~ %r{/api/v1/user/(login|register)}
        authenticate_request!
      end
    end

    mount V1::User # 挂载具体的业务逻辑
    mount V1::Topic # 挂载话题相关的API
    mount V1::Article # 挂载文章相关的API
    mount V1::Admin # 挂载管理员相关的API

    after do
      if @current_user_id && token_needs_refresh?
        new_token = generate_new_token
        header "X-New-Token", new_token[:token]
        header "X-Token-Expires-At", new_token[:expires_at].to_s
      end
    end
  end
end

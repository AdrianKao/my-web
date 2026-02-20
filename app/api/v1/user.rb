# app/api/v1/user.rb
module V1
  class User < Grape::API
    resource :user do
      desc "\u8FD4\u56DE\u7528\u6237\u4FE1\u606F"
      get do
        data = UserService.get_user_info(current_user.id)
        if data[:success]
          success(data[:data], "\u83B7\u53D6\u7528\u6237\u4FE1\u606F\u6210\u529F")
        else
          error(404, data[:message])
        end
      end

      desc "\u7528\u6237\u767B\u5F55"
      params do
        requires :username, type: String, desc: "\u7528\u6237\u540D"
        requires :password, type: String, desc: "\u5BC6\u7801"
      end
      post :login do
        data = UserService.login(params[:username], params[:password])
        if data[:success]
          success(data[:data], "\u767B\u5F55\u6210\u529F")
        else
          error(401, data[:message])
        end
      end

      desc "\u7528\u6237\u9000\u51FA"
      post :logout do
        { success: true, message: "\u9000\u51FA\u6210\u529F" }
      end

      desc "\u7528\u6237\u6CE8\u518C"
      params do
        requires :username, type: String, desc: "\u7528\u6237\u540D"
        requires :password, type: String, desc: "\u5BC6\u7801"
        requires :email, type: String, desc: "\u90AE\u7BB1"
      end
      post :register do
        data = UserService.register(params)
        if data[:success]
          success(data[:data], "\u6CE8\u518C\u6210\u529F")
        else
          error(400, data[:message])
        end
      end

      desc "\u5237\u65B0token"
      post :refresh_token do
        token_data = UserService.generate_token(current_user.id)
        success({ token: token_data[:token], expires_at: token_data[:expires_at] }, "token\u5237\u65B0\u6210\u529F")
      end
    end
  end
end

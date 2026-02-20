module V1
  class Admin < Grape::API
    resource :admin do
      desc "\u5BA1\u6838\u6587\u7AE0"
      params do
        requires :article_id, type: Integer, desc: "\u6587\u7AE0ID"
        requires :action, type: String, values: %w[approved rejected], desc: "\u64CD\u4F5C\uFF08approved / reject\uFF09"
        requires :reason, type: String, desc: "\u5BA1\u6838\u539F\u56E0"
        requires :user_id, type: Integer, desc: "\u7BA1\u7406\u5458ID"
      end
      post :approve do
        article_id = params[:article_id]
        action = params[:action]
        reason = params[:reason]
        user_id = params[:user_id]
        # 这里应该添加实际的审核文章逻辑
        data = AdminService.approve_article(article_id, action, reason, user_id)
        if data[:success]
          success(data[:data], "\u5BA1\u6838\u6587\u7AE0\u6210\u529F")
        else
          error(data[:message], 400)
        end
      end
    end
  end
end

module V1
  class Article < Grape::API
    resource :articles do
      # 1 发布文章
      desc "\u53D1\u5E03\u6587\u7AE0"
      params do
        requires :title, type: String, desc: "\u6587\u7AE0\u6807\u9898"
        requires :content, type: String, desc: "\u6587\u7AE0\u5185\u5BB9"
        # requires :user_id, type: Integer, desc: '用户ID'
        requires :category_id, type: Integer, desc: "\u6587\u7AE0\u7C7B\u522BID"
      end
      post :publish_article do
        # 这里应该添加实际的发布文章逻辑
        data = ArticleService.create_article(params[:user_id], params[:title], params[:content], params[:category_id])
        if data[:success]
          success(data[:data], "\u53D1\u5E03\u6587\u7AE0\u6210\u529F")
        else
          error(data[:message], 400)
        end
      end

      # 2 获取文章详情，需要选择文章类别
      desc "\u83B7\u53D6\u6587\u7AE0\u8BE6\u60C5"
      params do
        requires :id, type: Integer, desc: "\u6587\u7AE0ID"
      end
      get :article_detail do
        # 这里应该添加实际的获取文章详情逻辑
        data = ArticleService.get_article_detail(params[:id])
        if data[:success]
          success(data[:data], "\u83B7\u53D6\u6587\u7AE0\u8BE6\u60C5\u6210\u529F")
        else
          error(data[:message], 400)
        end
      end

      # 3 获取文章评论
      desc "\u83B7\u53D6\u6587\u7AE0\u8BC4\u8BBA"
      params do
        requires :id, type: Integer, desc: "\u6587\u7AE0ID"
        optional :page, type: Integer, default: 1, desc: "\u9875\u7801"
        optional :per_page, type: Integer, default: 10, desc: "\u6BCF\u9875\u6570\u91CF"
      end
      get :article_comments do
        # 这里应该添加实际的获取文章评论逻辑
        data = ArticleService.get_article_comments(params[:id], params[:page], params[:per_page])
        if data[:success]
          success(data[:data], "\u83B7\u53D6\u6587\u7AE0\u8BC4\u8BBA\u6210\u529F")
        else
          error(data[:message], 400)
        end
      end

      # 4 发布文章评论
      desc "\u53D1\u5E03\u6587\u7AE0\u8BC4\u8BBA"
      params do
        requires :id, type: Integer, desc: "\u6587\u7AE0ID"
        requires :user_id, type: Integer, desc: "\u7528\u6237ID"
        requires :content, type: String, desc: "\u8BC4\u8BBA\u5185\u5BB9"
      end
      post :add_comment do
        # 这里应该添加实际的发布评论逻辑
        data = ArticleService.create_comment(params[:id], params[:user_id], params[:content])
        if data[:success]
          success(data[:data], "\u53D1\u5E03\u6587\u7AE0\u8BC4\u8BBA\u6210\u529F")
        else
          error(data[:message], 400)
        end
      end

      # 5 删除文章评论
      desc "\u5220\u9664\u6587\u7AE0\u8BC4\u8BBA"
      params do
        requires :id, type: Integer, desc: "\u6587\u7AE0ID"
        requires :comment_id, type: Integer, desc: "\u8BC4\u8BBAID"
        requires :user_id, type: Integer, desc: "\u7528\u6237ID"
      end
      post :delete_comment do
        # 这里应该添加实际的删除评论逻辑
        data = ArticleService.delete_comment(params[:id], params[:comment_id], params[:user_id])
        if data[:success]
          success(data[:data], "\u5220\u9664\u6587\u7AE0\u8BC4\u8BBA\u6210\u529F")
        else
          error(data[:message], 400)
        end
      end

      # 6 返回文章类别
      desc "\u8FD4\u56DE\u6587\u7AE0\u7C7B\u522B"
      get :categories do
        # 这里应该添加实际的获取文章类别逻辑
        data = ArticleService.get_categories
        if data[:success]
          success(data[:data], "\u83B7\u53D6\u6587\u7AE0\u7C7B\u522B\u6210\u529F")
        else
          error(data[:message], 400)
        end
      end

      # 7 搜索文章接口（文章内容、标题）
      desc "\u641C\u7D22\u6587\u7AE0\u63A5\u53E3"
      params do
        requires :keyword, type: String, desc: "\u6587\u7AE0\u5185\u5BB9\u5173\u952E\u8BCD"
        optional :page, type: Integer, default: 1, desc: "\u9875\u7801"
        optional :per_page, type: Integer, default: 10, desc: "\u6BCF\u9875\u6570\u91CF"
      end
      post :article_search do
        # 这里应该添加实际的搜索文章逻辑
        data = ArticleService.search_articles(params)
        if data[:success]
          success(data[:data], "\u641C\u7D22\u6587\u7AE0\u6210\u529F")
        else
          error(data[:message], 400)
        end
      end

      # 8 点赞文章
      desc "\u70B9\u8D5E\u6587\u7AE0"
      params do
        requires :id, type: Integer, desc: "\u6587\u7AE0ID"
        requires :user_id, type: Integer, desc: "\u7528\u6237ID"
      end
      post :like_article do
        # 这里应该添加实际的点赞文章逻辑
        data = ArticleService.like_article(params[:id], params[:user_id])
        if data[:success]
          success(data[:data], "\u70B9\u8D5E\u6587\u7AE0\u6210\u529F")
        else
          error(data[:message], 400)
        end
      end

      # 9 取消点赞文章
      desc "\u53D6\u6D88\u70B9\u8D5E\u6587\u7AE0"
      params do
        requires :id, type: Integer, desc: "\u6587\u7AE0ID"
        requires :user_id, type: Integer, desc: "\u7528\u6237ID"
      end
      post :unlike_article do
        # 这里应该添加实际的取消点赞文章逻辑
        data = ArticleService.unlike_article(params[:id], params[:user_id])
        if data[:success]
          success(data[:data], "\u53D6\u6D88\u70B9\u8D5E\u6587\u7AE0\u6210\u529F")
        else
          error(data[:message], 400)
        end
      end
    end
  end
end

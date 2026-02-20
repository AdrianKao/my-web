module V1
  class Topic < Grape::API
    resource :topic do
      # 1 发布话题
      desc "\u53D1\u5E03\u8BDD\u9898"
      params do
        requires :title, type: String, desc: "\u8BDD\u9898\u6807\u9898"
        requires :content, type: String, desc: "\u8BDD\u9898\u5185\u5BB9"
        requires :user_id, type: Integer, desc: "\u7528\u6237ID"
      end
      post :publish_topic do
        result = TopicService.create_topic(params[:user_id], params[:title], params[:content])
        if result[:success]
          success(result[:data], "\u53D1\u5E03\u8BDD\u9898\u6210\u529F")
        else
          error(400, result[:message])
        end
      end

      # 2 获取话题详情
      desc "\u83B7\u53D6\u8BDD\u9898\u8BE6\u60C5"
      params do
        requires :id, type: Integer, desc: "\u8BDD\u9898ID"
      end
      get :topic_detail do
        result = TopicService.get_topic_detail(params[:id])
        if result[:success]
          success(result[:data], "\u83B7\u53D6\u8BDD\u9898\u8BE6\u60C5\u6210\u529F")
        else
          error(404, result[:message])
        end
      end

      # 3 获取话题列表
      desc "\u83B7\u53D6\u8BDD\u9898\u5217\u8868"
      params do
        optional :page, type: Integer, default: 1, desc: "\u9875\u7801"
        optional :per_page, type: Integer, default: 10, desc: "\u6BCF\u9875\u6570\u91CF"
      end
      get :topic_list do
        result = TopicService.get_topic_list(params[:page], params[:per_page])
        if result[:success]
          success(result[:data], "\u83B7\u53D6\u8BDD\u9898\u5217\u8868\u6210\u529F")
        else
          error(400, result[:message])
        end
      end

      # 4 点赞话题
      desc "\u70B9\u8D5E\u8BDD\u9898"
      params do
        requires :id, type: Integer, desc: "\u8BDD\u9898ID"
        requires :user_id, type: Integer, desc: "\u7528\u6237ID"
      end
      post :like_topic do
        result = TopicService.like_topic(params[:id], params[:user_id])
        if result[:success]
          success(result[:data], "\u70B9\u8D5E\u8BDD\u9898\u6210\u529F")
        else
          error(400, result[:message])
        end
      end

      # 5 取消点赞话题
      desc "\u53D6\u6D88\u70B9\u8D5E\u8BDD\u9898"
      params do
        requires :id, type: Integer, desc: "\u8BDD\u9898ID"
        requires :user_id, type: Integer, desc: "\u7528\u6237ID"
      end
      post :unlike_topic do
        result = TopicService.unlike_topic(params[:id], params[:user_id])
        if result[:success]
          success(result[:data], "\u53D6\u6D88\u70B9\u8D5E\u8BDD\u9898\u6210\u529F")
        else
          error(400, result[:message])
        end
      end

      # 6 评论话题
      desc "\u8BC4\u8BBA\u8BDD\u9898"
      params do
        requires :id, type: Integer, desc: "\u8BDD\u9898ID"
        requires :user_id, type: Integer, desc: "\u7528\u6237ID"
        requires :content, type: String, desc: "\u8BC4\u8BBA\u5185\u5BB9"
      end
      post :add_comments do
        result = TopicService.comment_topic(params[:id], params[:user_id], params[:content])
        if result[:success]
          success(result[:data], "\u8BC4\u8BBA\u8BDD\u9898\u6210\u529F")
        else
          error(400, result[:message])
        end
      end

      # 7 获取话题评论列表
      desc "\u83B7\u53D6\u8BDD\u9898\u8BC4\u8BBA\u5217\u8868"
      params do
        requires :id, type: Integer, desc: "\u8BDD\u9898ID"
        optional :page, type: Integer, default: 1, desc: "\u9875\u7801"
        optional :per_page, type: Integer, default: 10, desc: "\u6BCF\u9875\u6570\u91CF"
      end
      get :topic_comments do
        result = TopicService.get_topic_comments(params[:id], params[:page], params[:per_page])
        if result[:success]
          success(result[:data], "\u83B7\u53D6\u8BDD\u9898\u8BC4\u8BBA\u5217\u8868\u6210\u529F")
        else
          error(400, result[:message])
        end
      end

      # 8 删除话题
      desc "\u5220\u9664\u8BDD\u9898"
      params do
        requires :id, type: Integer, desc: "\u8BDD\u9898ID"
        requires :user_id, type: Integer, desc: "\u7528\u6237ID"
      end
      post :delete_topic do
        result = TopicService.delete_topic(params[:id], params[:user_id])
        if result[:success]
          success(result[:data], "\u5220\u9664\u8BDD\u9898\u6210\u529F")
        else
          error(400, result[:message])
        end
      end

      # 9 删除评论
      desc "\u5220\u9664\u8BC4\u8BBA"
      params do
        requires :id, type: Integer, desc: "\u8BDD\u9898ID"
        requires :comment_id, type: Integer, desc: "\u8BC4\u8BBAID"
        requires :user_id, type: Integer, desc: "\u7528\u6237ID"
      end
      post :delete_comment do
        result = TopicService.delete_comment(params[:id], params[:comment_id], params[:user_id])
        if result[:success]
          success(result[:data], "\u5220\u9664\u8BC4\u8BBA\u6210\u529F")
        else
          error(400, result[:message])
        end
      end
    end
  end
end

class ArticleService
  # 1 发布文章
  # @param user_id [Integer] 用户ID
  # @param title [String] 文章标题
  # @param content [String] 文章内容
  # @param category_id [Integer] 文章分类ID
  # @return [Hash] 发布结果
  def self.create_article(user_id, title, content, category_id)
    article = Article.create!(user_id: user_id, title: title, content: content, category_id: category_id)
    # 需要加入审核的队列
    {
      success: true,
      message: "\u53D1\u5E03\u6210\u529F\uFF0C\u7B49\u5F85\u5BA1\u6838",
      data: {
        article_id: article.id
      }
    }
  end

  # 2 获取文章详情
  # @param article_id [Integer] 文章ID
  # @return [Hash] 文章详情
  def self.get_article_detail(article_id)
    article = Article.approved.where(id: article_id).first
    if article
      {
        success: true,
        message: "\u83B7\u53D6\u6587\u7AE0\u8BE6\u60C5\u6210\u529F",
        data: {
          id: article.id,
          title: article.title,
          content: article.content,
          user_id: article.user_id,
          user_name: article.user.username,
          category_id: article.category_id,
          category_name: article.category.name,
          created_at: article.created_at,
          updated_at: article.updated_at,
          comments_count: article.comments_count
        }
      }
    else
      {
        success: false,
        message: "\u6587\u7AE0\u4E0D\u5B58\u5728"
      }
    end
  end

  # 3 获取文章评论
  # @param article_id [Integer] 文章ID
  # @param page [Integer] 页码
  # @param per_page [Integer] 每页数量
  # @return [Hash] 文章评论列表
  def self.get_article_comments(article_id, page = 1, per_page = 10)
    # 这里应该添加实际的获取文章评论逻辑
    comments = ArticleComment.where(article_id: article_id).order(created_at: :desc).page(page).per(per_page).to_a
    {
      success: true,
      message: "\u83B7\u53D6\u6587\u7AE0\u8BC4\u8BBA\u6210\u529F",
      data: {
        comments: comments,
        pagination: {
          page: page,
          per_page: per_page,
          total: comments.total_count,
          total_pages: comments.total_pages
        }
      }
    }
  end

  # 4 发布文章评论
  # @param article_id [Integer] 文章ID
  # @param user_id [Integer] 用户ID
  # @param content [String] 评论内容
  # @return [Hash] 发布结果
  def self.create_comment(article_id, user_id, content)
    # 这里应该添加实际的发布评论逻辑
    # 为了演示，直接返回评论成功的响应
    article = Article.approved.where(id: article_id).first
    if article
      comment = ArticleComment.create!(article_id: article_id, user_id: user_id, content: content)
      {
        success: true,
        message: "\u8BC4\u8BBA\u6210\u529F",
        data: {
          comment_id: comment.id
        }
      }
    else
      {
        success: false,
        message: "\u6587\u7AE0\u4E0D\u5B58\u5728"
      }
    end
  end

  # 5 删除文章评论
  # @param article_id [Integer] 文章ID
  # @param comment_id [Integer] 评论ID
  # @param user_id [Integer] 用户ID
  # @return [Hash] 删除结果
  def self.delete_comment(article_id, comment_id, user_id)
    # 这里应该添加实际的删除评论逻辑
    comment = ArticleComment.where(article_id: article_id, id: comment_id, user_id: user_id).first
    if comment
      comment.destroy
      {
        success: true,
        message: "\u5220\u9664\u8BC4\u8BBA\u6210\u529F"
      }
    else
      {
        success: false,
        message: "\u8BC4\u8BBA\u4E0D\u5B58\u5728\u6216\u7528\u6237\u6743\u9650\u4E0D\u8DB3"
      }
    end
  end

  # 6 返回文章类别
  def self.get_categories
    # 这里应该添加实际的获取文章类别逻辑
    categories = Category.all.map { |c| { id: c.id, name: c.name } }
    # 为了演示，直接返回文章类别列表
    {
      success: true,
      message: "\u83B7\u53D6\u6587\u7AE0\u7C7B\u522B\u6210\u529F",
      data: {
        categories: categories
      }
    }
  end

  # 7 搜索文章接口
  # @param params [Hash] 搜索参数
  # @option params [String] :keyword 搜索关键词
  # @option params [Integer] :page 页码
  # @option params [Integer] :per_page 每页数量
  # @return [Hash] 搜索结果
  def self.search_articles(params)
    # 这里应该添加实际的搜索文章逻辑
    keyword = params[:keyword] || ""
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    #     response = ElasticsearchClient.search(
    #       index: 'my_articles', # 指定索引名称
    #       body: {
    #         # 重点在这里：只包含 article_id 字段
    #         _source: ["article_id"],
    #         query: {
    #           bool: {
    #             must: [
    #               {
    #                 multi_match: {
    #                   query:  keyword,
    #                   fields: ["user_name", "category_name", "title^3", "content"]
    #                 }
    #               }
    #             ],
    #             filter: [
    #               { term: { status: 1 } } # 只搜已审批
    #             ]
    #           }
    #         },
    #         sort: [
    #           { _score: { order: "desc" } }, # 评分优先
    #           { created_at: { order: "desc" } } # 时间次之
    #         ]
    #       }
    #     )


    #     # 从ES响应中提取文章列表
    #     article_ids = response['hits']['hits'].map { |hit| hit['_source']['article_id'] }


    query_hash = {
      _source: [ "article_id" ],
      query: {
        bool: {
          must: [
            {
              multi_match: {
                query:  keyword,
                fields: [ "title^3", "content" ]
              }
            }
          ],
          filter: [
            { term: { status: 1 } }  # 只顯示已審批
          ]
        }
      },
      sort: [
        { _score: { order: "desc" } },
        { created_at: { order: "desc" } }
      ]
    }

    response = Article.search(query_hash).page(page).per(per_page)

    articles = response.records.includes(:user, :category)

    # 分頁資訊給 view 用（如果不用 Kaminari/Pagy 的 helper）
    total_count  = response.results.total
    current_page = page
    total_pages  = (total_count.to_f / per_page).ceil
    # 为了演示，直接返回搜索结果
    {
      success: true,
      message: "\u641C\u7D22\u6587\u7AE0\u6210\u529F",
      data: {
        articles: articles.map { |a| {
          id: a.id,
          title: a.title,
          content: a.content,
          user_id: a.user_id,
          user_name: a.user.username,
          category_id: a.category_id,
          category_name: a.category.name,
          created_at: a.created_at
        }},
        pagination: {
          page: params[:page] || 1,
          per_page: params[:per_page] || 10,
          total: total_count,
          total_pages: total_pages
        }
      }
    }
  end

  # 8 点赞文章
  # @param article_id [Integer] 文章ID
  # @param user_id [Integer] 用户ID
  # @return [Hash] 点赞结果
  def self.like_article(article_id, user_id)
    # 这里应该添加实际的点赞文章逻辑
    # 为了演示，直接返回点赞成功的响应
    article = Article.approved.where(id: article_id).first
    if article
      like_record = LikeRecord.create!(user_id: user_id, likeable_type: "Article", likeable_id: article_id)
      {
        success: true,
        message: "\u70B9\u8D5E\u6210\u529F"
      }
    else
      {
        success: false,
        message: "\u6587\u7AE0\u4E0D\u5B58\u5728"
      }
    end
  end

  # 8 点赞文章
  # @param article_id [Integer] 文章ID
  # @param user_id [Integer] 用户ID
  # @return [Hash] 点赞结果
  def self.like_article(article_id, user_id)
    # 这里应该添加实际的点赞文章逻辑
    # 为了演示，直接返回点赞成功的响应
    article = Article.approved.where(id: article_id).first
    if article
      existing_like = LikeRecord.where(user_id: user_id, likeable_type: "Article", likeable_id: article_id).first
      if existing_like
        {
          success: false,
          message: "\u7528\u6237\u5DF2\u70B9\u8D5E"
        }
      else
        {
          success: true,
          message: "\u70B9\u8D5E\u6210\u529F"
        }
      end
    else
      {
        success: false,
        message: "\u6587\u7AE0\u4E0D\u5B58\u5728"
      }
    end
  end

  # 9 取消点赞文章
  # @param article_id [Integer] 文章ID
  # @param user_id [Integer] 用户ID
  # @return [Hash] 取消点赞结果
  def self.unlike_article(article_id, user_id)
    # 这里应该添加实际的取消点赞文章逻辑
    article = Article.approved.where(id: article_id).first
    if article
      existing_like = LikeRecord.where(user_id: user_id, likeable_type: "Article", likeable_id: article_id).first
      if existing_like
        existing_like.destroy
        {
          success: true,
          message: "\u53D6\u6D88\u70B9\u8D5E\u6210\u529F"
        }
      else
        {
          success: false,
          message: "\u7528\u6237\u672A\u70B9\u8D5E\u8FC7\u8BE5\u6587\u7AE0"
        }
      end
    else
      {
        success: false,
        message: "\u6587\u7AE0\u4E0D\u5B58\u5728"
      }
    end
  end
end

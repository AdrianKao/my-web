class TopicService
  # 1 发布话题
  def self.create_topic(user_id, title, content)
    topic = Topic.create!(user_id: user_id, title: title, content: content)
    {
      success: true,
      message: "\u53D1\u5E03\u6210\u529F",
      data: { topic_id: topic.id }
    }
  end

  # 2 获取话题详情
  def self.get_topic_detail(topic_id)
    topic = Topic.find_by(id: topic_id)
    if topic
      {
        success: true,
        data: {
          id: topic.id,
          title: topic.title,
          content: topic.content,
          user_id: topic.user_id,
          user_name: topic.user.username,
          created_at: topic.created_at,
          updated_at: topic.updated_at,
          likes_count: topic.likes_count,
          comments_count: topic.comments_count
        }
      }
    else
      {
        success: false,
        message: "\u8BDD\u9898\u4E0D\u5B58\u5728"
      }
    end
  end

  # 3 获取话题列表
  def self.get_topic_list(page = 1, per_page = 10)
    topics = Topic.order(created_at: :desc).page(page).per(per_page)
    total = topics.total_count
    total_pages = topics.total_pages

    topic_list = topics.map do |topic|
      {
        id: topic.id,
        title: topic.title,
        content: topic.content,
        user_id: topic.user_id,
        user_name: topic.user.username,
        created_at: topic.created_at,
        updated_at: topic.updated_at,
        likes_count: topic.likes_count,
        comments_count: topic.comments_count
      }
    end

    {
      success: true,
      message: "\u83B7\u53D6\u8BDD\u9898\u5217\u8868\u6210\u529F",
      data: {
        topics: topic_list,
        pagination: {
          page: page,
          per_page: per_page,
          total: total,
          total_pages: total_pages,
          total_records: total
        }
      }
    }
  end

  # 4 点赞话题
  def self.like_topic(topic_id, user_id)
    # 这里应该添加实际的点赞逻辑，比如创建点赞记录
    # 检查用户是否已经点赞过该话题
    existing_like = LikeRecord.where(user_id: user_id, likeable_type: "Topic", likeable_id: topic_id).first
    if existing_like
      return {
        success: false,
        message: "\u7528\u6237\u5DF2\u70B9\u8D5E\u8FC7\u8BE5\u8BDD\u9898"
      }
    end

    like_record = LikeRecord.create!(user_id: user_id, likeable_type: "Topic", likeable_id: topic_id)
    topic = Topic.where(id: topic_id, user_id: user_id).last
    topic.likes_count += 1
    topic.save!
    # 为了演示，直接返回点赞成功的响应
    {
      success: true,
      message: "\u70B9\u8D5E\u6210\u529F",
      data: {
        likes_count: topic.likes_count
      }
    }
  end

  # 5 取消点赞话题
  def self.unlike_topic(topic_id, user_id)
    # 检查用户是否点赞过该话题
    existing_like = LikeRecord.where(user_id: user_id, likeable_type: "Topic", likeable_id: topic_id).first
    if !existing_like
      return {
        success: false,
        message: "\u7528\u6237\u672A\u70B9\u8D5E\u8FC7\u8BE5\u8BDD\u9898"
      }
    end
    # 删除点赞记录
    existing_like.destroy
    # 这里应该添加实际的取消点赞逻辑，比如删除点赞记录
    topic = Topic.where(id: topic_id, user_id: user_id).last
    if topic && topic.likes_count > 0
      topic.likes_count -= 1
      topic.save!
    end
    # 为了演示，直接返回取消点赞成功的响应
    {
      success: true,
      message: "\u53D6\u6D88\u70B9\u8D5E\u6210\u529F",
      data: {
        likes_count: topic.likes_count
      }
    }
  end

  # 6 评论话题
  def self.comment_topic(topic_id, user_id, content)
    # 这里应该添加实际的评论逻辑，比如创建评论记录
    comment = TopicComment.create!(topic_id: topic_id, user_id: user_id, content: content)
    # 为了演示，直接返回评论成功的响应
    {
      success: true,
      message: "\u8BC4\u8BBA\u6210\u529F",
      data: {
        comment_id: comment.id
      }
    }
  end

  # 7 获取话题评论列表
  def self.get_topic_comments(topic_id, page = 1, per_page = 10)
    # 这里应该添加实际的获取评论列表逻辑
    comments = TopicComment.where(topic_id: topic_id).order(created_at: :desc).page(page).per(per_page)
    total = comments.total_count
    total_pages = comments.total_pages



    # 为了演示，直接返回模拟的评论列表
    comments = comments.map do |comment|
      {
        id: comment.id,
        topic_id: comment.topic_id,
        user_id: comment.user_id,
        user_name: comment.user.username,
        content: comment.content,
        created_at: comment.created_at
      }
    end

    {
      success: true,
      message: "\u83B7\u53D6\u8BDD\u9898\u8BC4\u8BBA\u5217\u8868\u6210\u529F",
      data: {
        comments: comments,
        pagination: {
          page: page,
          per_page: per_page,
          total: total,
          total_pages: total_pages,
          total_records: total
        }
      }
    }
  end

  # 8 删除话题
  def self.delete_topic(topic_id, user_id)
    topic = Topic.find_by(id: topic_id)
    if topic
      if topic.user_id == user_id
        topic.destroy
        {
          success: true,
          message: "\u5220\u9664\u8BDD\u9898\u6210\u529F"
        }
      end
    end
  end

  # 9 删除评论
  def self.delete_comment(topic_id, comment_id, user_id)
    # 这里应该添加实际的删除评论逻辑，比如查找评论并删除
    comment = TopicComment.where(topic_id: topic_id, id: comment_id).last
    if comment && comment.user_id == user_id
      comment.destroy
      {
        success: true,
        message: "\u5220\u9664\u8BC4\u8BBA\u6210\u529F"
      }
    end
  end
end

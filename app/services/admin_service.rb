class AdminService
  def self.approve_article(article_id, action, reason, user_id)
    article = Article.find(article_id)
    ReviewLog.create!(
      article_id: article_id,
      action: action,
      reason: reason,
      reviewer_id: user_id
    )
    {
      success: true,
      message: "文章 #{article_id} 已#{action}审核"
    }
  end
end

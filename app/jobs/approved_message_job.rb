class ApprovedMessageJob < ApplicationJob
  queue_as :approved

  def perform(article_id)
    # 1. 从数据库中获取文章详情
    article = Article.pending.where(id: article_id).first
    # 2. 发消息通知管理员需要审批
    Rails.logger.info("文章 #{article_id} 需要被审核")
    # Do something later
  end
end

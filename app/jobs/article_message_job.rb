class ArticleMessageJob < ApplicationJob
  queue_as :article_message

  def perform(article_id)
    # 1. 从数据库中获取文章详情
    review = ReviewLog.find_by(article_id: article_id)
    # 2. 发消息通知用户文章已被审核
    Rails.logger.info("文章 #{article_id} 已被审核，状态为 #{review.action_text}, 审核人 #{review.reason}")
    # Do something later
  end
end

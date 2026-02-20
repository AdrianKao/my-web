class ReviewLog < ApplicationRecord
  belongs_to :reviewer, class_name: "User"
  belongs_to :article
  validates :action, presence: true, inclusion: { in: %w[approved rejected] }
  validates :reason, presence: true
  # 审核通过的日志
  scope :approved, -> { where(action: "approved") }
  # 未审核通过的日志
  scope :rejected, -> { where(action: "rejected") }

  # 保存后更新文章状态,并发通知文章作者,并发索引文章到es
  after_save :update_article_status, :notify_article_author, :index_article_to_es

  def action_text
    action == "approved" ? "\u5BA1\u6838\u901A\u8FC7" : "\u5BA1\u6838\u672A\u901A\u8FC7"
  end

  private

  def update_article_status
    if action == "approved"
      article.update!(status: "approved")
    elsif action == "rejected"
      article.update!(status: "rejected")
    end
  end

  def index_article_to_es
    # 并发索引文章到es
    ArticleEsJob.perform_later("Article", article_id)
  end

  def notify_article_author
    # 并发通知文章作者
    ArticleMessageJob.perform_later(article_id)
  end
end

class Article < ApplicationRecord
  # 引入 Searchable 模块，elasticsearch 索引配置
  include Searchable

  # 将索引名称设置为 'my_articles'
  index_name "my_articles"

  # 使用我们在 Concern 里定义的配置方法
  configure_elasticsearch do
    # 文章状态
    indexes :status, type: "integer"
    # 文章id
    indexes :article_id, type: "integer"
    indexes :user_id, type: "integer"
    # 文章作者
    indexes :user_name, type: "text", analyzer: "ik_max_word", search_analyzer: "ik_smart"
    # 文章分类
    indexes :category_name, type: "text", analyzer: "ik_max_word", search_analyzer: "ik_smart"
    indexes :category_id, type: "integer"
    # 文章标题
    indexes :title, type: "text", analyzer: "ik_max_word", search_analyzer: "ik_smart"
    # 文章内容
    indexes :content, type: "text", analyzer: "ik_max_word", search_analyzer: "ik_max_word"
    # 文章创建时间
    indexes :created_at, type: "date"
  end

  # 这个方法决定了哪些数据会被发往 ES
  def as_indexed_json(options = {})
    {
      status: es_status,
      article_id: id,
      user_id: user_id,
      category_id: category_id,
      user_name: user.username,
      category_name: category.name,
      title: title,
      content: content,
      created_at: created_at.strftime("%Y-%m-%d")
    }
  end

  belongs_to :user
  belongs_to :category
  has_many :article_comments

  validates :status, presence: true, inclusion: { in: %w[draft pending approved rejected] }
  # status (draft / pending / approved / rejected)
  # 审核通过的文章
  scope :approved, -> { where(status: "approved") }
  # 未审核通过的文章
  scope :rejected, -> { where(status: "rejected") }
  # 草稿文章
  scope :draft, -> { where(status: "draft") }
  # 待审核文章
  scope :pending, -> { where(status: "pending") }

  after_create :send_approval_message

  # 文章创建后，发送审批消息到队列
  def send_approval_message
    ApprovedMessageJob.perform_later(id)
  end

  def es_status
    case status
    when "approved" then 1
    when "rejected" then 4
    when "draft" then 2
    when "pending" then 3
    else 0
    end
  end

  def approved?
    status == "approved"
  end

  def rejected?
    status == "rejected"
  end

  def draft?
    status == "draft"
  end

  def pending?
    status == "pending"
  end
end

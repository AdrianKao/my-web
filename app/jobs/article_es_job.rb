class ArticleEsJob < ApplicationJob
  queue_as :es_index_queue

  def perform(object_type, object_id)
    case object_type
    when "Article"
      article = Article.find(object_id)
      article.index! if article.status == 1
    end
  end
end

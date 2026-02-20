class LikeRecord < ApplicationRecord
  belongs_to :user
  scope :likeable_type, ->(type) { where(likeable_type: type) }
  scope :topic, -> { where(likeable_type: "Topic") }
  scope :article, -> { where(likeable_type: "Article") }
end

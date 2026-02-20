class Topic < ApplicationRecord
  belongs_to :user
  has_many :topic_comments, dependent: :destroy

  validates :user_id, :title, :content, presence: true
end

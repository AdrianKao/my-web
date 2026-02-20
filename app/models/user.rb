class User < ApplicationRecord
  has_many :topics, dependent: :destroy
  has_many :topic_comments, dependent: :destroy

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  def self.create_user(params)
    User.create!(
      username: params[:username],
      email: params[:email],
      password: params[:password]
    )
  end
end

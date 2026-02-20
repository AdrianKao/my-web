class Category < ApplicationRecord
  has_many :articles
  validates :name, presence: true, uniqueness: true

  # 初始化文章分类
  def self.init_categories
    categories = [
      { id: 1, name: "\u6280\u672F" },
      { id: 2, name: "\u751F\u6D3B" },
      { id: 3, name: "\u4F53\u80B2" },
      { id: 4, name: "\u5A31\u4E50" }
    ]
    categories.each do |category|
      Category.find_or_create_by!(id: category[:id], name: category[:name])
    end
  end
end

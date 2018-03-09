class RecipeSummary < ApplicationRecord
  # アソシエーション
  # has_many :menus
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user

  has_many :recipes, dependent: :destroy

  # 以下2つの方法をとっても材料データがとれない
  # has_many :recipe_ingredients, through: :recipes, source: :ingredient
  # has_many :ingredients, through: :recipes

  belongs_to :user
  
  # validate
  validates :name, presence: true, length: {in: 1..128}
  validates :weight, presence: true, numericality: {greater_than: 0, less_than: 8192}
  validates :protein, presence: true
  validates :fat, presence: true
  validates :carbohydrate, presence: true
  validates :content, presence: true, length: {in: 1..512}
  
end

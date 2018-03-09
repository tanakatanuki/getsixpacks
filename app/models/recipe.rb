class Recipe < ApplicationRecord
  # アソシエーション
  # belongs_to :ingredient

  # recipeとingredientの関係をコメントアウトし、rails db:seedしてから復活させる
  has_many :ingredients
  belongs_to :recipe_summary
  belongs_to :user
  
  # validate
  validates :name, presence: true, length: {in: 1..140}
  validates :weight, presence: true, numericality: {greater_than: 0, less_than: 10000}
end

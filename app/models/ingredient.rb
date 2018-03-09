class Ingredient < ApplicationRecord
  # アソシエーション
  # 子側なので、recipeを保存しないと、rails db:seedがきかない
  # よって、recipeとingredientの関係をコメントアウトし、rails db:seedしてから復活させる
  belongs_to :recipe
  belongs_to :ingredient_category
  
  validates :name, presence: true, length: {in: 1..100}
  validates :protein, presence: true
  validates :fat, presence: true
  validates :carbohydrate, presence: true
  validates :category_id, presence: true
end

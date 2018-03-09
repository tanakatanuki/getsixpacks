class Favorite < ApplicationRecord
  # 一度だけお気に入りに入れられる
  validates :user_id, uniqueness: {:scope => :recipe_summary_id}

  # アソシエーション。多側
  belongs_to :user
  belongs_to :recipe_summary
end

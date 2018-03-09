class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  # アソシエーション。関連テーブルの関係では、全て1側。userが消えたら、作成データも削除
  has_many :recipes, dependent: :destroy
  has_many :recipe_summaries, dependent: :destroy
  # has_many :menus, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_recipe_summaries, through: :favorites, source: :recipe_summary
  
  # validate
  validates :email, presence: true, uniqueness: true, length: {maximum: 255}, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
  

end

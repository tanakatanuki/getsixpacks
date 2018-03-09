Rails.application.routes.draw do
  devise_for :users
  # deviseで使うため
  # root "recipes#index"
  root "recipes#all_users_recipes"
  
  # 全ユーザーの投稿レシピ一覧
  get "/all_users_recipes", to: "recipes#all_users_recipes"
  post "/all_users_recipes", to: "recipes#all_users_recipes"
  
  # 各ユーザーが投稿したレシピとメニュー
  resources :users, only: [:new, :create, :show, :edit] do
    resources :recipes
    resources :menus
  end
  
  # レシピに対してお気に入り
  resources :recipes, only: [:index, :show] do
    resources :favorites, only: [:create, :destroy]
  end
  
  # こんだて。レシピの組み合わせ
  resources :menus, only: [:index, :show]
  
  # 計算結果を表示する
  post "/calculation", to: "recipes#calculatecalorie"
  get "/calculation", to: "recipes#calculatecalorie"
  
  # セレクトタブを動的に
  get "/select", to: "recipes#select"
  
  # 開発環境でletter_openerを使う
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at:"/letter_opener"
  end
end

class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    # favorite = current_user.favorite_recipe_summaries.create(recipe_summary_id: params[:id])
    # a = current_user.favorite_recipe_summaries.create(id: params[:recipe_id])
    favorite = Favorite.create(user_id: current_user.id, recipe_summary_id: params[:recipe_id])
    # puts "id..#{params[:id]}"
    # puts "recipe_id..#{params[:recipe_id]}"
    # puts "user_id..#{favorite.user_id}"
    # puts "recipe_summary_id..#{favorite.recipe_summary_id}"
    # redirect_to all_users_recipes_path
    if params[:flag] == "/all_users_recipes"
      redirect_to all_users_recipes_path, success: "お気に入りにしました"
    else
      redirect_to user_recipes_path(current_user.id), success: "お気に入りにしました"
    end
  end
  
  def destroy
    # favorite = current_user.favorite_recipe_summaries.find_by(recipe_summary_id: params[:recipe_id])
    favorite = Favorite.find_by(user_id: current_user.id, recipe_summary_id: params[:recipe_id]).destroy
    # puts "d--id..#{params[:id]}"
    # puts "d--recipe_id..#{params[:recipe_id]}"
    # puts "d--user_id..#{favorite.user_id}"
    # puts "d--recipe_summary_id..#{favorite.recipe_summary_id}"
    # puts "flag...#{params[:flag]}"
    if params[:flag] == "/all_users_recipes"
      redirect_to all_users_recipes_path, success: "お気に入りを削除しました"
    else
      redirect_to user_recipes_path(current_user.id), success: "お気に入りを削除しました"
    end
  end
end

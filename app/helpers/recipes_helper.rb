module RecipesHelper
  #==============================================================================
  # 他のユーザーページに入れないように
  #==============================================================================
  def forbid_recipe
    if (params[:user_id].to_i != current_user.id)
      redirect_to all_users_recipes_path
    end
  end
end

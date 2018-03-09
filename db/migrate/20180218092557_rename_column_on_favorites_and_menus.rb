class RenameColumnOnFavoritesAndMenus < ActiveRecord::Migration[5.1]
  def change
    rename_column :favorites, :recipe_id, :recipe_summary_id
    rename_column :menus, :recipe_id, :recipe_summary_id
  end
end

class RenameColumnFromcategoryIdToIngredientCategoryId < ActiveRecord::Migration[5.1]
  def change
    rename_column :ingredients, :category_id, :ingredient_category_id
  end
end

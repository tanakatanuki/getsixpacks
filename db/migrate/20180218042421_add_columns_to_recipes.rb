class AddColumnsToRecipes < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :recipe_summary_id, :integer
  end
end

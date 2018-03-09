class ChangeFromStringToIntegerOnIngredient < ActiveRecord::Migration[5.1]
  def change
    remove_column :ingredients, :category, :string
    add_column :ingredients, :category_id, :integer
  end
end

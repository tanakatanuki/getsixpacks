class CreateIngredientCategory < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredient_categories do |t|
      t.string :name
      
      t.timestamps
    end
  end
end

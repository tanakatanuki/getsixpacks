class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.float :protein
      t.float :fat
      t.float :carbohydrate

      t.timestamps
    end
  end
end

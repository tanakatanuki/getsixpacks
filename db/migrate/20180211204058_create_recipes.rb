class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.float :weight
      t.integer :ingredient_id
      t.integer :user_id

      t.timestamps
    end
  end
end

class CreateRecipeSummaries < ActiveRecord::Migration[5.1]
  def change
    create_table :recipe_summaries do |t|
      t.string :name
      t.float :protein
      t.float :fat
      t.float :carbohydrate
      t.float :weight
      t.float :calorie
      t.integer :user_id

      t.timestamps
    end
  end
end

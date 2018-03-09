class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus do |t|
      t.string :name
      t.integer :recipe_id
      t.integer :user_id

      t.timestamps
    end
  end
end

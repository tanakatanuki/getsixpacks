class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      # t.string :name
      # t.string :email
      t.boolean :premium_member
      t.float :weight
      t.float :fat_percent
      t.integer :activity_level
      t.integer :setting_calorie

      t.timestamps
    end
  end
end

class AddContentToRecipesummaries < ActiveRecord::Migration[5.1]
  def change
    add_column :recipe_summaries, :content, :text
  end
end

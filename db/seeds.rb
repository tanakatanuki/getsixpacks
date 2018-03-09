# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# coding utf-8

require "csv"

# CSV.foreach("db/sample_recipe.csv", encoding: 'Shift_JIS:UTF-8') do |row|
#     # Recipe.create(name: row[1], weight: row[2], ingredient_id: row[3], user_id: row[4])
#     Recipe.create(name: row[0], weight: row[1], ingredient_id: row[2], user_id: row[3])
# end

# csvにidが含まれているので、シーケンスがセットされない。
# シーケンスをセットする必要がある。
# connection = ActiveRecord::Base.connection();
# connection.execute("select setval('recipe_id_seq', (select max(id) from recipes))")

# CSV.foreach("db/sample_recipe_summary.csv") do |row|
#     RecipeSummary.create(id: row[0], name: row[1], protein: row[2], fat: row[3], carbohydrate: row[4], weight: row[5], calorie: row[6], user_id: row[7], content: row[8])
# end

# アソシエーションをコメントアウトしてから
# CSV.foreach("db/sample_ingredient.csv", encoding: 'Shift_JIS:UTF-8') do |row|
#     # Ingredient.create(name: row[1], protein: row[2], fat: row[3], carbohydrate: row[4])
#     Ingredient.create(name: row[0], protein: row[1], fat: row[2], carbohydrate: row[3], category_id: row[4])
# end

CSV.foreach("db/sample_ingredient_category.csv", encoding: 'Shift_JIS:UTF-8') do |row|
    IngredientCategory.create(name: row[0])
end

# シーケンスをセットする必要がある。
# connection = ActiveRecord::Base.connection();
# connection.execute("select setval('ingredient_id_seq', (select max(id) from ingredients))")

# CSV.foreach("db/sample_recipe_summary.csv", encoding: 'Shift_JIS:UTF-8') do |row|
#     # Ingredient.create(name: row[1], protein: row[2], fat: row[3], carbohydrate: row[4])
#     Ingredient.create(name: row[0], protein: row[1], fat: row[2], carbohydrate: row[3])
# end

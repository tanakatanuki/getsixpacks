class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :edit, :update, :destroy, :create]
  before_action :forbid_recipe, only:[:index, :new, :edit, :update, :destroy, :create]
  before_action :set_recipe_summary, only: [:edit, :update, :destroy]
  
  # 全ユーザーの投稿一覧
  def all_users_recipes
    @view_limit = 30
    @sort_desc = 1

    @recipe_summary = RecipeSummary.new
    # @recipe_summaries = RecipeSummary.all
    @ingredients = Ingredient.all
    @ingredients_name = Ingredient.pluck :name
    @ingredient_categories = IngredientCategory.all
    if user_signed_in? then
      @favorites = Favorite.where(user_id: current_user.id)
    end

    # 
    if @sort_desc == 1
      # @recipe_summaries = RecipeSummary.all.order(created_at: :desc).limit(@view_limit)
      @recipe_summaries = RecipeSummary.all.order(id: :desc).limit(@view_limit)
    else
      # @recipe_summaries = RecipeSummary.all.order(created_at: :asc).limit(@view_limit)
      @recipe_summaries = RecipeSummary.all.order(id: :asc).limit(@view_limit)
    end


    # 検索機能
    if request.post?
      recipe_ids = Recipe.where(ingredient_id: params[:search][:ingredient]).pluck :recipe_summary_id
      if @sort_desc == 1
        # @recipe_summaries = RecipeSummary.where(id: recipe_ids).order(created_at: :desc).limit(@view_limit)
        @recipe_summaries = RecipeSummary.where(id: recipe_ids).order(id: :desc).limit(@view_limit)
      else
        # @recipe_summaries = RecipeSummary.where(id: recipe_ids).order(created_at: :asc).limit(@view_limit)
        @recipe_summaries = RecipeSummary.where(id: recipe_ids).order(id: :asc).limit(@view_limit)
      end
    end
  end
  
  # ajax。2つのセレクトタブを連動
  # 複数のセレクトタブを使えなかったので、封印
  # def select
  #   # @ingredient = Ingredient.where(category: params[:ingredient_category])
  #   puts "1..#{params[:ingredient_category1]}"
  #   puts "2..#{params[:ingredient_category2]}"
  #   if params[:ingredient_category1]
  #     puts "1111"
  #     @ingredient1 = Ingredient.where(category: params[:ingredient_category1])
  #   elsif params[:ingredient_category2]
  #     puts "2222"
  #     @ingredient2 = Ingredient.where(category: params[:ingredient_category2])
  #   end
  # end

  # ユーザーの投稿一覧
  def index
    @sort_desc = 0
    
    # @ingredients = Ingredient.all
    @ingredients_name = Ingredient.pluck :name
    # @recipes = Recipe.all
    @recipes = Recipe.where(user_id: params[:user_id])
    @recipe_summary = RecipeSummary.new
    @favorites = Favorite.where(user_id: current_user.id)
    @favorites_ids = Favorite.where(user_id: current_user.id).pluck(:recipe_summary_id)
    # puts @favorites_ids
    # puts @favorites[1].recipe_summary_id
    @favorite_recipe_summaries = RecipeSummary.where(id: @favorites_ids)
    # puts @favorite_recipe_summaries[0].name

    # 
    # @recipe_summaries = RecipeSummary.where(user_id: params[:user_id])
    if @sort_desc == 1
      # @recipe_summaries = RecipeSummary.all.order(created_at: :desc).limit(@view_limit)
      @recipe_summaries = RecipeSummary.where(user_id: params[:user_id]).order(id: :desc).limit(@view_limit)
    else
      # @recipe_summaries = RecipeSummary.all.order(created_at: :asc).limit(@view_limit)
      @recipe_summaries = RecipeSummary.where(user_id: params[:user_id]).order(id: :asc).limit(@view_limit)
    end
  end
  
  def new
    @ingredient_number = 15
    @recipe = Recipe.new
    # @recipes = Recipe.all
    # @recipe_summary = RecipeSummary.new
    @ingredients = Ingredient.all
    @ingredient_categories = IngredientCategory.all
  end
  
  # =============================================================================
  # 保存
  # =============================================================================
  def create
    # puts params[:recipe][:ingredient][0]
    # puts params[:recipe][:ingredient][1]
    # puts params[:recipe][:ingredient][2]
    # puts params[:recipe][:weight][0]
    # puts params[:recipe][:weight][1]
    # puts params[:recipe][:weight][2]
    # puts params[:recipe][:name]
    
    # 初期化
    # protein_sum = 0
    # fat_sum = 0
    # carbohydrate_sum = 0
    # weight_sum = 0
    # dummy_val = 0
    protein_sum, fat_sum, carbohydrate_sum, weight_sum, dummy_val = initialize_value(0, 5)
    puts "p..#{protein_sum},f..#{fat_sum}, c..#{carbohydrate_sum}, w..#{weight_sum}, d..#{dummy_val}"

    # for cnt in 0..params[:recipe][:ingredient].length-1 do
    # (0..params[:recipe][:ingredient].length-1).each do |cnt|
    (0..recipe_ingredient_params.length-1).each do |cnt|
      # i = params[:recipe][:ingredient][cnt]
      # w = params[:recipe][:weight][cnt].to_i
      i = recipe_ingredient_params[cnt]
      w = recipe_weight_params[cnt].to_i
      
      dummy_val, protein_sum, fat_sum, carbohydrate_sum, weight_sum =
        check_recipe_form(i, w, dummy_val, protein_sum, fat_sum, carbohydrate_sum, weight_sum)

      # idが0以外、かつ、weightが空ではない、かつ、weight>0
      # if !i.to_i.zero? && w.present? && w.to_i > 0 && w.to_i < 10000 then
      #   ingredient = Ingredient.find(i)
      #   puts "ing..#{i}, weight..#{w}"
        
      #   protein_sum += ingredient.protein * w.to_i / 100
      #   fat_sum += ingredient.fat * w.to_i / 100
      #   carbohydrate_sum += ingredient.carbohydrate * w.to_i / 100
      #   puts "P..#{protein_sum},F..#{fat_sum},C..#{carbohydrate_sum}"
        
      #   weight_sum += w.to_i
      # end
    end
    
    # pfcからカロリー計算
    # calorie_sum = 4 * protein_sum + 9 * fat_sum + 4 * carbohydrate_sum
    calorie_sum = calculate_calorie_from_pfc(protein_sum, fat_sum, carbohydrate_sum)
    puts "calorie..#{calorie_sum}"
    
    # 先に親テーブルのrecipe_summaryを保存
    @recipe_summary = RecipeSummary.create(name: params[:recipe][:name],
      protein: protein_sum, fat: fat_sum, carbohydrate: carbohydrate_sum,
      weight: weight_sum, calorie: calorie_sum,
      content: params[:recipe][:content],
      user_id: current_user.id)

    # recipeをここで保存する
    # for cnt in 0..params[:recipe][:ingredient].length-1 do
    (0..recipe_ingredient_params.length-1).each do |cnt|
      # i = params[:recipe][:ingredient][cnt]
      # w = params[:recipe][:weight][cnt].to_i
      i = recipe_ingredient_params[cnt]
      w = recipe_weight_params[cnt].to_i
      
      # idが0以外、かつ、weightが空ではない、かつ、weight>0
      # if !i.to_i.zero? && w.present? && w.to_i > 0 then
      if validate_recipe_form?(i, w) then
        # ingredient = Ingredient.find(i)
        puts "変更後----> ing..#{i}, weight..#{w}"

        # レシピ保存。親の保存のあとでないと、エラーが出て、dbに保存できない
        Recipe.create(name: params[:recipe][:name], ingredient_id: i, weight: w, user_id: current_user.id, recipe_summary_id: @recipe_summary.id)
      end
    end
    
    # このsaveはいるか?
    if @recipe_summary.save
      redirect_to user_recipes_path, success: "レシピを保存しました"
    else
      puts"保存に失敗　→　#{new_user_recipe_path}"
      flash[:danger] = "レシピの保存に失敗しました"
      # renderだとmissing templateエラーになる。
      # render new_user_recipe_path(current_user.id)
      redirect_to new_user_recipe_path(current_user.id)
    end
  end
  
  def edit
    @ingredient_number = 15
    @recipes = Recipe.where(recipe_summary_id: params[:id])
    # @recipe_summary = RecipeSummary.find(params[:id])
    # set_recipe_summary
    @ingredients = Ingredient.all
    # @params_id = params[:id]
    # puts "edit-action-----paramsid..#{@params_id}"
    @ingredient_categories = IngredientCategory.all
  end
  
  # =============================================================================
  # 編集
  # 場合分けが長くなった
  # =============================================================================
  def update
    puts "---updateスタート..."
    # @recipe_summary = RecipeSummary.find(params[:id])
    # set_recipe_summary    
    
    # -------------------------------------
    # recipe_summaryの更新
    # -------------------------------------
    # 初期化
    # protein_sum = 0
    # fat_sum = 0
    # carbohydrate_sum = 0
    # weight_sum = 0
    # ingredient_count = 0
    protein_sum, fat_sum, carbohydrate_sum, weight_sum, ingredient_count = initialize_value(0, 5)
    puts "p..#{protein_sum},f..#{fat_sum}, c..#{carbohydrate_sum}, w..#{weight_sum}, i..#{ingredient_count}"

    # 登録済みのレシピの編集
    # for cnt in 0..params[:recipe][:ingredient].length-1 do
    (0..recipe_ingredient_params.length-1).each do |cnt|
      # i = params[:recipe][:ingredient][cnt]
      # w = params[:recipe][:weight][cnt].to_i
      i = recipe_ingredient_params[cnt]
      w = recipe_weight_params[cnt].to_i
      
      ingredient_count, protein_sum, fat_sum, carbohydrate_sum, weight_sum =
        check_recipe_form(i, w, ingredient_count, protein_sum, fat_sum, carbohydrate_sum, weight_sum)
      # idが0以外、かつ、weightが空ではない、かつ、weight>0
      # if !i.to_i.zero? && w.present? && w.to_i > 0 then
      # idが空以外、かつ、weightが空ではない、かつ、weight>

      # if i.present? && w.present? && w.to_i > 0 && w.to_i < 10000 then
      #   ingredient = Ingredient.find(i)
      #   puts "ing..#{i}, ingname..#{ingredient.name}, weight..#{w}"
        
      #   protein_sum += ingredient.protein * w.to_i / 100
      #   fat_sum += ingredient.fat * w.to_i / 100
      #   carbohydrate_sum += ingredient.carbohydrate * w.to_i / 100
      #   puts "P..#{protein_sum},F..#{fat_sum},C..#{carbohydrate_sum}"
        
      #   weight_sum += w.to_i
      #   ingredient_count += 1
      # end
    end

    # あらたに付け加えた場合
    # for cnt in 0..params[:add_recipe][:ingredient].length-1 do
    # (0..params[:add_recipe][:ingredient].length-1).each do |cnt|
    (0..add_recipe_ingredient_params.length-1).each do |cnt|
      # i = params[:add_recipe][:ingredient][cnt]
      # w = params[:add_recipe][:weight][cnt].to_i
      i = add_recipe_ingredient_params[cnt]
      w = add_recipe_weight_params[cnt].to_i
      
      ingredient_count, protein_sum, fat_sum, carbohydrate_sum, weight_sum =
        check_recipe_form(i, w, ingredient_count, protein_sum, fat_sum, carbohydrate_sum, weight_sum)
      # idが0以外、かつ、weightが空ではない、かつ、weight>0
      # if !i.to_i.zero? && w.present? && w.to_i > 0 then
      # idが空以外、かつ、weightが空ではない、かつ、0<weight<10000

      # if i.present? && w.present? && w.to_i > 0 && w.to_i < 10000 then
      #   ingredient = Ingredient.find(i)
      #   puts "ing..#{i}, ingname..#{ingredient.name}, weight..#{w}"
        
      #   protein_sum += ingredient.protein * w.to_i / 100
      #   fat_sum += ingredient.fat * w.to_i / 100
      #   carbohydrate_sum += ingredient.carbohydrate * w.to_i / 100
      #   puts "P..#{protein_sum},F..#{fat_sum},C..#{carbohydrate_sum}"
        
      #   weight_sum += w.to_i
      #   ingredient_count += 1
      # end
    end

    # 
    # calorie_sum = 4 * protein_sum + 9 * fat_sum + 4 * carbohydrate_sum
    calorie_sum = calculate_calorie_from_pfc(protein_sum, fat_sum, carbohydrate_sum)
    puts "*****----calorie..#{calorie_sum}"
    
    # 材料が何も選ばれていなかったばあい、recipesとrecipe_summaryは削除する
    # weight_sum <= 0という条件では、1,-1,1,-1と入力された場合、意図したとおり動かない
    if ingredient_count == 0 then
      puts "recipe_summary.destroy..."
      @recipe_summary.destroy

      @recipes = Recipe.where(recipe_summary_id: params[:id])
      @recipes.each do |recipe|
        recipe.destroy
      end
      # redirectでメソッドを抜けてくれないので、returnを加えた
      return redirect_to user_recipes_path
    end
    
    # レシピ集約情報を保存。更新失敗なら編集ページに飛ばす
    # 例のごとく、renderでひっかかる。
    # ここでひっかからないように、上の方で入力チェックすることにした
    unless @recipe_summary.update(name: params[:recipe][:name], protein: protein_sum, fat: fat_sum, carbohydrate: carbohydrate_sum, weight: weight_sum, calorie: calorie_sum,
      content: params[:recipe][:content],user_id: current_user.id) then
      flash[:danger] = "レシピの更新に失敗しました"
      # renderだとエラーになる。redirect_toにしたが、上の方でチェックしているためここには入らないだろう
      # render edit_user_recipe_path(current_user.id)
      redirect_to edit_user_recipe_path(current_user.id)
    end

    # -------------------------------------
    # recipeの更新
    # -------------------------------------
    # 個別レシピは以下で保存する
    @recipes = Recipe.where(recipe_summary_id: params[:id])

    # 既存のレシピを編集した場合
    # for cnt in 0..params[:recipe][:ingredient].length-1 do
    # (0..params[:recipe][:ingredient].length-1).each do |cnt|
    (0..recipe_ingredient_params.length-1).each do |cnt|
      # i = params[:recipe][:ingredient][cnt]
      # w = params[:recipe][:weight][cnt].to_i
      i = recipe_ingredient_params[cnt]
      w = recipe_weight_params[cnt].to_i
      
      # idが0以外、かつ、weightが空ではない、かつ、weight>0
      # if !i.to_i.zero? && w.present? && w.to_i > 0 then
      # idが空以外、かつ、weightが空ではない、かつ、0<weight<10000
      # if i.present? && w.present? && w.to_i > 0 && w.to_i < 10000 then
      if validate_recipe_form?(i, w) then
        # ingredient = Ingredient.find(i)
        puts "変更後----> ing..#{i}, weight..#{w}, recipe..#{@recipes[cnt].name}, recipeid..#{@recipes[cnt].id}"

        # レシピ情報更新。親の保存のあとでないと、エラーが出て、dbに保存できない
        # Recipe.create(name: params[:recipe][:name], ingredient_id: i, weight: w, user_id: current_user.id, recipe_summary_id: @recipe_summary.id)
        unless @recipes[cnt].update(name: params[:recipe][:name], ingredient_id: i, weight: w, user_id: current_user.id, recipe_summary_id: @recipe_summary.id) then
          flash[:danger] = "レシピの更新に失敗しました"
          # renderでエラーになる
          # render edit_user_recipe(current_user.id)
          redirect_to edit_user_recipe(current_user.id)
        end
      else
        @recipes[cnt].destroy
      end
    end

    # 新たにレシピを加えた場合
    # (0..params[:add_recipe][:ingredient].length-1).each do |cnt|
    (0..add_recipe_ingredient_params.length-1).each do |cnt|
      # i = params[:add_recipe][:ingredient][cnt]
      # w = params[:add_recipe][:weight][cnt].to_i
      i = add_recipe_ingredient_params[cnt]
      w = add_recipe_weight_params[cnt].to_i
      
      # idが0以外、かつ、weightが空ではない、かつ、weight>0
      # if !i.to_i.zero? && w.present? && w.to_i > 0 then
      # idが空以外、かつ、weightが空ではない、かつ、weight>0
      # if i.present? && w.present? && w.to_i > 0 && w.to_i < 10000 then
      if validate_recipe_form?(i, w) then
        # ingredient = Ingredient.find(i)
        puts "add---変更後----> ing..#{i}, weight..#{w}"

        # レシピを付け加えた場合のため、レシピを保存する。親の保存のあとでないと、エラーが出て、dbに保存できない
        unless Recipe.create(name: params[:recipe][:name], ingredient_id: i, weight: w, user_id: current_user.id, recipe_summary_id: @recipe_summary.id) then
          flash[:danger] = "レシピの更新に失敗しました"
          # renderだとエラーになる
          # render edit_user_recipe(current_user.id)
          redirect_to edit_user_recipe(current_user.id)
        end
      end
    end
    
    # ここまで来たということは、保存に全て成功したといえる。
    redirect_to user_recipes_path, success: "レシピを更新しました"
    return
    # redirect_to recipes_path
  end
  
  def destroy
    # @recipe_summary = RecipeSummary.find(params[:id])
    # set_recipe_summary
    puts "----edestroy action...id=#{params[:id]}, name..#{@recipe_summary.name}"
    @recipe_summary.destroy
    flash[:success] = "レシピを削除しました"
    redirect_to user_recipes_path
  end
  
  # =============================================================================
  # dpで計算するメソッド
  # 
  # 
  # =============================================================================
  def calculatecalorie
    # 入力チェック
    # チェックボックスにチェックがなかったとき(params[:recipe_summary]自体が存在しない場合)
    # check_param(params[:recipe_summary])
    if params[:recipe_summary].nil?
      if user_signed_in?
        redirect_to user_recipes_path(current_user.id)
        return
      else
        redirect_to all_users_recipes_path
        return
      end
    end
    
    if params[:setting_calorie].to_i <= 0
      if user_signed_in?
        redirect_to user_recipes_path(current_user.id)
        return
      else
        redirect_to all_users_recipes_path
        return
      end
    end
    
    @ingredients_name = Ingredient.pluck :name

    # 文字列配列を渡してもokみたい
    # 配列を渡すので、where句を使用
    @recipe_summaries = RecipeSummary.where(id: recipe_summary_params)
    # 数値で取得できる
    # @a = recipe_summary_params[0]
    
    # 文字列配列で取得できる
    # @b = recipe_summary_params
    # puts @b
    
    # レシピの表示順を変えた場合(descにした場合)、paramの順が逆になるため、元に戻す
      # puts "sort_desc...#{params[:sort_desc].to_i},view_limit...#{@view_limit}"
    if params[:sort_desc].to_i == 1
      # puts "sort_desc"
      recipe_summary_params_reverse = params[:recipe_summary][:recipe_ids].reverse 
      @c = recipe_summary_params_reverse.map(&:to_i)
      # puts "c0..#{@c[0]},c1..#{@c[1]}"
    else
      @c = recipe_summary_params.map(&:to_i)
    end
    
    # whereでidをキーにして抽出後、
    # pluck(:カラム名)で特定列の配列を取得できる
    array_w = RecipeSummary.where(id: recipe_summary_params).pluck(:calorie)
    array_v = RecipeSummary.where(id: recipe_summary_params).pluck(:weight)
    n = array_w.length
    # w = 500
    w = params[:setting_calorie].to_i
    puts "---set calorie...#{w}"

    # 別々のオブジェクトとして定義するために、mapを使い初期化する
    dp = Array.new(n+1).map{Array.new(w+1, 0)}
    @weight_sum_dp = solve_DP(array_w, array_v, w, n, dp)[n][w]
    puts "重さ..#{@weight_sum_dp}"
    
    # 条件を満たすitemを取得
    item = solve_DP_get_item(dp, array_w, array_v)
    @d=[]
    for i in 0...item.length
        puts "i=#{i}..#{item[i]}....#{@c[i]}" if !item[i].zero?
        @d << @c[i] if !item[i].zero?
    end
    puts "aaaaa..=> #{@d}"
    @result_recipes = RecipeSummary.where(id: @d)
    @calorie_sum_dp = RecipeSummary.where(id: @d).pluck(:calorie).inject(:+)
    puts "カロリー...#{@calorie_sum_dp}"

    @protein_sum = @result_recipes.pluck(:protein).inject(:+)
    @fat_sum = @result_recipes.pluck(:fat).inject(:+)
    @carbohydrate_sum = @result_recipes.pluck(:carbohydrate).inject(:+)
    
    @selected_recipes = RecipeSummary.where(id: @c)
    @setting_calorie = w

  end



  private


  #==============================================================================
  # パラメ
  #==============================================================================
  def recipe_params
    params.require(:recipe).permit(:name)
  end
  
  def recipe_summary_params
    params[:recipe_summary][:recipe_ids]

    # ストロングパラメータでの取得はまた今度
    # params.require(:recipe_summary).permit(recipe_ids:[])
    # params.require(:recipe_summary).permit(recipe_ids:[]).map(&:to_i)
  end
  
  # 各材料のid配列
  def recipe_ingredient_params
    params[:recipe][:ingredient]
  end
  
  # 各材料の重量配列
  def recipe_weight_params
    params[:recipe][:weight]
  end

  # 新たに加えた各材料のid配列
  def add_recipe_ingredient_params
    params[:add_recipe][:ingredient]
  end
  
  # 新たに加えた各材料の重量配列
  def add_recipe_weight_params
    params[:add_recipe][:weight]
  end

  #==============================================================================
  # idをキーにしてインスタンス変数作成
  #==============================================================================
  def set_recipe_summary
    @recipe_summary = RecipeSummary.find(params[:id])
  end
  
  
  #==============================================================================
  # 入力チェック
  # redirectされずに、処理が進む。なんで?
  # ......
  #==============================================================================
  def check_param(param)
    if param.nil?
      if user_signed_in?
        puts"signedin------------"
        redirect_to user_recipes_path(current_user.id)
        return
      else
        puts"no------------------"
        redirect_to all_users_recipes_path
        return
      end
    end
  end

  #==============================================================================
  # 
  # idが空以外、かつ、weightが空ではない、かつ、0<weight<10000
  #==============================================================================
  def check_recipe_form(i, w, ingredient_count, protein_sum, fat_sum, carbohydrate_sum, weight_sum)
    # if i.present? && w.present? && w > 0 && w < 10000 then
    if validate_recipe_form?(i, w) then
      ingredient = Ingredient.find(i)
      puts "ing..#{i}, ingname..#{ingredient.name}, weight..#{w}"
      
      protein_sum += ingredient.protein * w / 100
      fat_sum += ingredient.fat * w / 100
      carbohydrate_sum += ingredient.carbohydrate * w / 100
      puts "P..#{protein_sum},F..#{fat_sum},C..#{carbohydrate_sum}"
      
      weight_sum += w
      ingredient_count += 1
    end
    
    [ingredient_count, protein_sum, fat_sum, carbohydrate_sum, weight_sum]
  end
  
  # レシピの入力フォームでの条件式。入力チェック
  def validate_recipe_form?(i, w)
    i.present? && w.present? && w > 0 && w < 10000
  end
  
  # カロリー計算
  def calculate_calorie_from_pfc(protein, fat, carbohydrate)
    4 * protein + 9 * fat + 4 * carbohydrate
  end
  
  # 変数の初期化
  def initialize_value(value, number)
    Array.new(number){value}
  end

  #==============================================================================
  #ナップサック問題をDPで解く
  #　
  #
  #==============================================================================
  def solve_DP(arr_weight, arr_value, max_weight, item_num, dp)
    for i in 0...item_num
      for j in 0..max_weight
        if arr_weight[i] > j then
          dp[i+1][j] = dp[i][j]
        else
          dp[i+1][j] = [
                      dp[i][j], 
                      dp[i][j-arr_weight[i]] + arr_value[i]
                      ].max
          # puts "i=#{i},j=#{j}, dp[i][j]..#{dp[i][j]}, dp[i-1][j]..#{dp[i-1][j]}"
        end
      end
    end
    # dpテーブルを返す
    return dp
  end

  #==============================================================================
  # ナップサック問題を解いたdpテーブル表を基に
  # 必要な品物を特定する
  #
  #==============================================================================
  def solve_DP_get_item(dp, arr_weight, arr_value)
    # 必要不要を格納する配列
    item = Array.new(arr_value.length)

    row_length = dp[0].length
    w = row_length - 1

    # デクリメントする
    (0..item.length-1).reverse_each do |i|
      puts "i..#{i}, dp[i][j]=#{dp[i][w]}, dp[i+1][j]=#{dp[i+1][w]}"
      if (0 <= w-arr_weight[i]) && (dp[i][w-arr_weight[i]]+arr_value[i] == dp[i+1][w]) then
        w -= arr_weight[i]
        item[i] = 1
        puts "ありitemi..#{i}"
      # 等しい場合持っていかない
      elsif dp[i][w] == dp[i+1][w]
        puts "なしitemi..#{i}"
        item[i] = 0
      # 実装エラー
      else
        item[i] =-1
      end
    end
    
    return item
  end

end

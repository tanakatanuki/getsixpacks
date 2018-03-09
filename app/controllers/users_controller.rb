class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :forbid_recipe
  before_action :set_user, only: [:edit, :update, :destroy]
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(current_user.id)
  end
  
  def update
    @user = User.find(current_user.id)
    if @user.update
      redirect_to user_recipes_path(current_user.id)
    else
      render user_recipes_path(current_user.id)
    end
  end


  private
  
  #==============================================================================
  # idをキーにしてインスタンス変数作成
  #==============================================================================
  def set_user
    @user = User.find(params[:id])
  end
end

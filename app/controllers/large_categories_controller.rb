class LargeCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]


  def index
    @large_categories = LargeCategory.where(user_id: current_user.id).order(created_at: :desc).page(params[:page])
    @large_category = LargeCategory.new
  end

  def create
    @large_category = current_user.large_categories.new(large_category_params)
    if @large_category.save
      redirect_to user_large_categories_path(current_user), notice: "カテゴリーを追加しました"
    else
      @large_categories = LargeCategory.where(user_id: current_user.id).page(params[:page])
      render 'index'
    end
  end

  def edit
  end

  def update
    if @large_category.update(large_category_params)
      redirect_to user_large_categories_path(current_user), notice: "カテゴリーを更新しました"
    else
      render "edit"
    end
  end

  def destroy
    @large_category = LargeCategory.find(params[:id])
    if @large_category.destroy
    redirect_to user_large_categories_path(current_user), notice: "カテゴリーを削除しました"
    else
      render "index"
    end
  end

  def search
    @large_categories = LargeCategory.includes([:small_categories, :genre]).where(user: current_user).references(:small_categories).search(params[:keyword]).page(params[:page])
  end

  before_action :check_guest, only: [:update, :destroy]
  def check_guest
    if @large_category.user.email == 'guest@example.com'
      redirect_to user_large_categories_path(current_user), notice: 'ゲストユーザーは編集・削除ができません。'
    end
  end

  private

  def large_category_params
    params.require(:large_category).permit(:problem, :solution, :genre_id)
  end

  def ensure_correct_user
    @large_category = LargeCategory.find(params[:id])
    unless @large_category.user == current_user
      redirect_to user_large_categories_path
    end
  end
end


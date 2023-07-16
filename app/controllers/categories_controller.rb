class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]
  before_action :set_stat_div, only: %i[index new edit update create]


  # GET /categories or /categories.json
  def index; end

  # GET /categories/1 or /categories/1.json
  def show; end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories or /categories.json
  def create
    @category = current_user.categories.new(category_params)

    if @category.name.blank? || @category.limit.blank?
      redirect_to new_category_path(author_id: current_user.id)
      flash[:notice] = 'Name and limit are required'
    elsif @category.limit > 1_000_000
      redirect_to new_category_path(author_id: current_user.id)
      flash[:notice] = 'Limit cannot exceed $1,000,000'
    elsif @category.save
      redirect_to categories_path
      flash[:notice] = 'Successfully created a category 🎉!'
    else
      render :new
    end
  end

  def set_stat_div
    @categories = current_user.categories.includes(:expenses).order(created_at: :desc)
    @latest = current_user.categories.includes(:expenses).order(created_at: :desc).limit(3)
    @total_sum_categories = current_user.categories
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    @category = Category.find(params[:id])
    @categories = Category.all

    if @category.expenses.sum(:amount) > params[:category][:limit].to_i
      flash[:notice] =
        'Your limit must be that same or equal to existing expenses for this category. Please increase limit.'
      redirect_to edit_category_path(@category)
    elsif @category.update(category_params)
      redirect_to categories_path
      flash[:notice] = 'Update successful 😊!'
    else
      render :edit
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path
    flash[:notice] = 'Category deleted 👋'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def category_params
    params.require(:category).permit(:name, :limit)
  end
end

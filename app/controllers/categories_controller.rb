class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ edit update destroy ]
  before_action :set_stat_div, only: %i[index new edit]


  # GET /categories or /categories.json
  def index
    
  end
  
  # GET /categories/1 or /categories/1.json
  def show
  end

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
    if @category.save
      redirect_to categories_path(author_id: current_user.id)
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
  
    if @category.expenses.sum(:amount) > params[:category][:limit].to_i
      flash.now[:notice] = "Category limit exceeded. Please adjust expenses."
      render :edit
    else
      if @category.update(category_params)
        redirect_to categories_path
      else
        render :edit
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path
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

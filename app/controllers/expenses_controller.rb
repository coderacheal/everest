class ExpensesController < ApplicationController
  # before_action :set_expense, only: %i[ show edit update destroy ]
  before_action :set_category, only: %i[index new create]
  before_action :set_stat_div, only: %i[index new edit update create]

  # GET /expenses or /expenses.json
  def index
    @category_expenses = Expense.where(category_id: params[:category_id])
    @expenses = @category.expenses.includes(:user).order(created_at: :desc)
    @total_amount = @expenses.sum(:amount)
    @category = Category.find(params[:category_id])
  end

  # GET /expenses/1 or /expenses/1.json
  def show
    @category = Category.find(params[:category_id])
    @expense = @category.expenses.find(params[:id])
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @category_expenses = @category.expenses.to_a
    @total_amount = @category_expenses.sum(&:amount)
  end

  # GET /expenses/1/edit
  def edit
    @category = Category.find(params[:category_id])
    @expense = Expense.find(params[:id])
  end

  def set_stat_div
    @categories = current_user.categories.includes(:expenses).order(created_at: :desc)
    @latest = current_user.categories.includes(:expenses).order(created_at: :desc).limit(3)
    @total_sum_categories = current_user.categories
  end

  # POST /expenses or /expenses.json

  def create
    @expense = @category.expenses.build(expense_params)

    if @expense.amount.present? && BigDecimal(@expense.amount).positive?
      @category_expenses = @category.expenses.to_a
      total_expenses_amount = @category_expenses.sum { |expense| BigDecimal(expense.amount) }

      if total_expenses_amount > @category.limit
        redirect_to new_category_expense_path, notice: 'Ops! Your expense amount is greater than your limit amount'
        return
      end
    else
      redirect_to new_category_expense_path, notice: 'Please enter a valid expense amount'
      return
    end

    if @expense.save
      @category.expenses << @expense
      redirect_to category_expenses_path(@category), notice: 'Successfully created an expense 🎉!'
    else
      render :new
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    @expense = Expense.find(params[:id])
    @category = Category.find(params[:category_id])

    return unless @category

    @category_expenses = @category.expenses.to_a
    total_expenses_amount = @category_expenses.sum(&:amount) - (@expense.amount.to_i || 0)

    if total_expenses_amount + params[:expense][:amount].to_i <= @category.limit
      if @expense.update(expense_params)
        redirect_to category_expenses_path, notice: 'Expense updated successfully 😊!'
      else
        flash.now[:alert] = 'Failed to update expense.'
        render :edit
      end
    else
      redirect_to edit_category_expense_path(@expense),
                  notice: 'Updating this expense would exceed the category limit.'
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    redirect_to category_expense_path
    flash[:notice] = 'Expense deleted 👋 !'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:category_id])
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount).merge(author_id: current_user.id)
  end
end

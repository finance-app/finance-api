class TransactionCategoriesController < ApplicationController
  before_action :set_transaction_category, only: [:edit, :destroy, :update]

  def index
    @transaction_categories = TransactionCategory.includes(
      :transactions,
    ).where(user: current_user).references(:transactions).order('name ASC')

    if params[:period_id]
      @transaction_categories = @transaction_categories.where(transactions: { period_id: params[:period_id] })
      @balances = BalanceBase.where(timeperiod_type: 'Period', timeperiod_id: params[:period_id], owner_type: 'TransactionCategory', transaction_type: nil).group(:owner_id, :type).sum(:value)
    elsif params[:budget_id]
      @transaction_categories = @transaction_categories.where(transactions: { budget_id: params[:budget_id] })
      @balances = BalanceBase.where(timeperiod_type: 'Budget', timeperiod_id: params[:budget_id], owner_type: 'TransactionCategory', transaction_type: nil).group(:owner_id, :type).sum(:value)
    else
      @balances = {}
    end
  end

  def show
    @transaction_category = TransactionCategory.where(
      transaction_categories: {
        user: current_user
      },
    ).find(params[:id])

    @balances = BalanceBase.where(owner: @transaction_category, timeperiod: nil, transaction_type: nil).group(:type).sum(:value) || {}
  end

  def edit
  end

  # PATCH/PUT /transaction_categories/1
  def update
    if @transaction_category.update(transaction_categories_params)
      head :no_content, status: :ok
    else
      render json: @transaction_category.errors, status: :unprocessable_entity
    end
  end

  def create
    @transaction_category = TransactionCategory.new(transaction_categories_params)
    @transaction_category.user = current_user

    if @transaction_category.save
      @balances = {}
      render :show, status: :created
    else
      render json: @transaction_category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @transaction_category.destroy
      head :no_content
    else
      render json: {transaction_category: ["can't have any associated transactions"]}, status: :conflict
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction_category
      @transaction_category = TransactionCategory.where(user: current_user).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_categories_params
      params.require(:transaction_category).permit(:name, :comment)
    end
end

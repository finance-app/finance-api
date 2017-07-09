class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :destroy, :update]

  def index
    @budgets = Budget.includes(:currency, :default_account).where(budgets: { user: current_user, currency: params[:currency_id] }.compact).references(:currencies)
    @balances = BalanceBase.where(timeperiod: @budgets, owner: nil, transaction_type: nil).group(:timeperiod_id, :type).sum(:value)
  end

  def show
    @balances = BalanceBase.where(timeperiod: @budget, owner: nil, transaction_type: nil).group(:type).sum(:value)
  end

  def edit
    @budget = Budget.where(user: current_user).find(params[:budget_id])
  end

  # PATCH/PUT /budget/1
  def update
    if @budget.update(budget_params)
      @balances = {}
      render :show, status: :ok
    else
      render json: @budget.errors, status: :unprocessable_entity
    end
  end

  def create
    @budget = Budget.new(budget_params)
    @budget.user = current_user
    @balances = {}

    if @budget.save
      render :show, status: :created
    else
      render json: @budget.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @budget.destroy
      head :no_content
    else
      render json: {budget: ["can't have any associated transactions"]}, status: :conflict
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      @budget = Budget.includes(:currency, :default_account).references(:currencies, :accounts).where(user: current_user).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_params
      params.require(:budget).permit(:name, :currency_id, :comment, :default_account_id)
    end
end

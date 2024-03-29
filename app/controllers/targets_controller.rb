class TargetsController < ApplicationController
  before_action :set_target, only: [:edit, :destroy, :update]

  def index
    @targets = Target.includes(
      :default_income_transaction_category,
      :default_expense_transaction_category,
      :incomes_transactions,
      :expenses_transactions,
      :budgets => [:currency],
    ).where({
      user: current_user,
      default_income_transaction_category: params[:default_income_transaction_category_id],
      default_expense_transaction_category: params[:default_expense_transaction_category_id]
    }.compact).references(:transaction_categories, :transactions, :budgets).order('targets.name COLLATE NOCASE')

    if params[:period_id]
      # If period is defined, return only targets which has transactions in this period
      @targets = @targets.where('transactions.period_id = ? OR expenses_transactions_targets.period_id = ?', params[:period_id], params[:period_id])

      @incomes_transactions = Hash[Transaction.where(source_type: 'Target', period_id: params[:period_id]).group(:source_id).count]
      @expenses_transactions = Hash[Transaction.where(destination_type: 'Target', period_id: params[:period_id]).group(:destination_id).count]
      @balances = BalanceBase.where(timeperiod_type: 'Period', timeperiod_id: params[:period_id], owner_type: 'Target', transaction_type: nil).group(:owner_id, :type).sum(:value)
    elsif params[:budget_id]
      # If budget is defined, find only targets, which have transactions in this budget,
      # but also fetch all associated budgets with targets.
      #
      # If show_empty param is present, return also targets, which have no transactions and no budgets assigned (newly created global targets).
      where = '((transactions.budget_id = ? OR expenses_transactions_targets.budget_id = ?) AND budgets.id IS NULL) OR (budgets_targets.target_id = targets.id AND budgets_targets.budget_id = ?)'
      if params[:show_empty]
        where += ' OR budgets.id IS NULL'
      end
      @targets = @targets.where(where, params[:budget_id], params[:budget_id], params[:budget_id])

      @incomes_transactions = Hash[Transaction.where(source_type: 'Target', budget_id: params[:budget_id]).group(:source_id).count]
      @expenses_transactions = Hash[Transaction.where(destination_type: 'Target', budget_id: params[:budget_id]).group(:destination_id).count]
      @balances = BalanceBase.where(timeperiod_type: 'Budget', timeperiod_id: params[:budget_id], owner_type: 'Target', transaction_type: nil).group(:owner_id, :type).sum(:value)
    else
      @incomes_transactions = Hash[Transaction.where(source_type: 'Target').group(:source_id).count]
      @expenses_transactions = Hash[Transaction.where(destination_type: 'Target').group(:source_id).count]

      # Currency mismatch!
      #@balances = BalanceBase.where(timeperiod: nil).where.not(owner: nil).group(:owner_id, :type).sum(:value)
      @balances = {}
    end

    case params[:sort_by]
    when 'favourite'
      @targets = @targets.reorder('favourite DESC', 'targets.name COLLATE NOCASE')
    else
      # Do nothing
    end
  end

  def show
    @target = Target.includes(
      :default_income_transaction_category,
      :default_expense_transaction_category,
    ).where(user: current_user).references(:transaction_categories).find(params[:id])

    show_helper
  end

  def edit
  end

  # PATCH/PUT /target/1
  def update
    @target.budgets = Budget.where(user: current_user).find(params[:budgets])

    if @target.update(target_params)
      head :no_content, status: :ok
    else
      render json: @target.errors, status: :unprocessable_entity
    end
  end

  def create
    @target = Target.new(target_params)
    @target.user = current_user
    @target.favourite = target_params[:favourite] || false

    if params[:budgets]
      @target.budgets = Budget.where(user: current_user).find(params[:budgets])
    end

    if @target.save
      @balances = {}
      render :show, status: :created
    else
      render json: @target.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @target.destroy
      head :no_content
    else
      render json: {target: ["can't have any associated transactions"]}, status: :conflict
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_target
      @target = Target.where(user: current_user).find(params[:target_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def target_params
      params.require(:target).permit(:name, :comment, :default_income_transaction_category_id, :default_expense_transaction_category_id, :sort_by, :favourite, :budgets, :show_empty)
    end

    def show_helper
      @balances = BalanceBase.where(owner: @target, timeperiod: nil, transaction_type: nil).group(:type).sum(:value) || {}
    end
end

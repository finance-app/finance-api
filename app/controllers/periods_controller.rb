class PeriodsController < ApplicationController
  before_action :set_period, only: [:edit, :destroy, :update, :close, :cycle, :reopen]

  def index
    @periods = Period.includes(
      :budget,
      :currency,
    ).where(user: current_user).where({budget: params[:budget_id]}.compact).order('start_date DESC')

    @transactions = Transaction.where(user: current_user).group(:period_id).count
    @balances = BalanceBase.where(timeperiod_type: 'Period', owner: nil, transaction_type: nil).group(:timeperiod_id, :type).sum(:value)
  end

  def show
    @period = Period.includes(
      :budget,
      :currency,
    ).where(user: current_user).references(:budgets, :currencies).find(params[:id])

    show_helper
  end

  def edit
  end

  # PATCH/PUT /periods/1
  def update
    if @period.update(periods_params)
      @balances = {}
      render :show, status: :ok
    else
      render json: @period.errors, status: :unprocessable_entity
    end
  end

  def create
    @period = Period.new(periods_params)
    @period.user = current_user

    if @period.save
      @balances = {}
      render :show, status: :created
    else
      render json: @period.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @period.destroy
      head :no_content
    else
      render json: {period: ["can't have any associated transactions"]}, status: :conflict
    end
  end

  # POST /periods/1/cycle
  def cycle
    if @period.end_date
      head :conflict
    else
      ActiveRecord::Base.transaction do
        @period.update_attribute(:end_date, Date.today)
        new_period = Period.new(budget: @period.budget, user: current_user)
        if new_period.save
          # Frontend relies on order here!
          @periods = [new_period, @period]

          @transactions = Transaction.where(user: current_user).group(:period_id).count
          @balances = BalanceBase.where(timeperiod_type: 'Period', owner: nil, transaction_type: nil).group(:timeperiod_id, :type).sum(:value)

          render :index, status: :created
        else
          render json: new_period.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # POST /periods/1/close
  def close
    if @period.end_date
      head :conflict
    else
      @period.update_attribute(:end_date, Date.today)
      show_helper
      render :show
    end
  end

  # POST /periods/1/reopen
  def reopen
    if @period.end_date
      @period.update_attribute(:end_date, nil)
      show_helper
      render :show
    else
      head :conflict
    end
  end

  # GET /periods/1/expenses
  def expenses
    @flexible_expenses = Expense.where(timeperiod_type: 'Period', timeperiod_id: (params[:period_id] || params[:id]), owner: nil, transaction_type: 'flexible').pluck(:date, :value).to_h
    @discretionary_expenses = Expense.where(timeperiod_type: 'Period', timeperiod_id: (params[:period_id] || params[:id]), owner: nil, transaction_type: 'discretionary').pluck(:date, :value).to_h
    @dates = (@flexible_expenses.keys + @discretionary_expenses.keys).uniq.sort
    @flexible_expenses = @dates.map {|date| @flexible_expenses[date] }
    @discretionary_expenses = @dates.map {|date| @discretionary_expenses[date] }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_period
      @period = Period.joins(:budget).where(user: current_user).find(params[:period_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def periods_params
      params.require(:period).permit(:name, :comment, :start_date, :end_date, :budget_id)
    end

    def show_helper
      @balances = BalanceBase.where(timeperiod_type: 'Period', timeperiod_id: params[:id], owner: nil, transaction_type: nil).group(:type).sum(:value) || {}

      @transactions = Transaction.includes(
        :transaction_category,
      ).references(:transaction_categories).where(period: params[:id], user: current_user).order('transactions.date DESC', 'transactions.updated_at DESC')

      target_ids = (Transaction.distinct.where(user: current_user, source_type: 'Target').pluck(:source_id) + Transaction.distinct.where(user: current_user, destination_type: 'Target').pluck(:destination_id)).uniq
      account_ids = (Transaction.distinct.where(user: current_user, source_type: 'Account').pluck(:source_id) + Transaction.distinct.where(user: current_user, destination_type: 'Account').pluck(:destination_id)).uniq

      @accounts = Account.where(user: current_user, id: account_ids).pluck(:id, :name)
      @targets = Target.where(user: current_user, id: target_ids).pluck(:id, :name)
    end
end

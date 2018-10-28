class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:edit, :destroy, :update]

  def index
    # TODO: Eagerly load Targets and Accounts
    @transactions = Transaction.includes(
      :period,
      :budget,
      :transaction_category,
    ).where(user: current_user).where({
      transaction_category: params[:transaction_category_id],
      type: params[:type],
    }.compact).references(:periods, :budgets).order('transactions.date DESC', 'transactions.created_at DESC')

    # Allow filtering by periods and budgets
    if params[:period_id]
      @transactions = @transactions.where(period: params[:period_id])
    elsif params[:budget_id]
      @transactions = @transactions.where(budget: params[:budget_id])
    end

    # Allow filtering by targets
    if params[:target_id]
      @transactions = @transactions.where(source_id: params[:target_id], source_type: 'Target').or(@transactions.where(destination_id: params[:target_id], destination_type: 'Target'))
    end

    # Allow filtering by accounts
    if params[:account_id]
      @transactions = @transactions.where(source_id: params[:account_id], source_type: 'Account').or(@transactions.where(destination_id: params[:account_id], destination_type: 'Account'))
    end

    # Allow filtering by value
    case params[:value]
    when 'income'
      @transactions = @transactions.where(destination_type: 'Account').or(@transactions.where(source_type: 'Target'))
    when 'expense'
      @transactions = @transactions.where(source_type: 'Account').or(@transactions.where(destination_type: 'Target'))
    else
    end

    target_ids = (Transaction.distinct.where(user: current_user, source_type: 'Target').pluck(:source_id) + Transaction.distinct.where(user: current_user, destination_type: 'Target').pluck(:destination_id)).uniq
    account_ids = (Transaction.distinct.where(user: current_user, source_type: 'Account').pluck(:source_id) + Transaction.distinct.where(user: current_user, destination_type: 'Account').pluck(:destination_id)).uniq

    @accounts = Account.where(user: current_user, id: account_ids).pluck(:id, :name)
    @targets = Target.where(user: current_user, id: target_ids).pluck(:id, :name)
  end

  def show
    # TODO: Eagerly load Targets and Accounts
    @transaction = Transaction.includes(
      :period,
      :budget,
      :transaction_category,
    ).where(
      periods: {
        budgets: {
          user: current_user,
        },
      },
    ).find(params[:id])
  end

  def edit
  end

  # PATCH/PUT /transaction/1
  def update
    additional_params = {}
    if params[:source_id]
      additional_params[:source] = params[:transaction_type] == 'income' ? Target.find(params[:source_id]) : Account.find(params[:source_id])
    else
      additional_params[:source] = nil
    end

    if params[:destination_id]
      additional_params[:destination] = params[:transaction_type] == 'income' ? Account .find(params[:destination_id]): Target.find(params[:destination_id])
    else
      additional_params[:destination] = nil
    end

    if @transaction.update(Hash[transaction_params.to_h].merge(additional_params))
      head :no_content, status: :ok
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.source_id
      @transaction.source = params[:transaction_type] == 'income' ? Target.find(@transaction.source_id) : Account.find(@transaction.source_id)
    else
      @transaction.source = nil
    end

    if @transaction.destination_id
      @transaction.destination = params[:transaction_type] == 'income' ? Account.find(@transaction.destination_id) : Target.find(@transaction.destination_id)
    else
      @transaction.destination = nil
    end

    # Cross-currencies transactions are not implemented
    if @transaction.account && @transaction.account.currency != @transaction.period.currency
      json = {}
      json[@transaction.destination_currency ? 'destination_id' : 'source_id'] = [" account currency does not match budget currency"]
      render json: json, status: :unprocessable_entity
    else

      # Table structure is ready for cross-currencies transactions
      # so we need to fill both source and destination currency.
      @transaction.source_currency = @transaction.destination_currency = @transaction.period.currency

      @transaction.user = current_user

      if @transaction.save
        render :show, status: :created
      else
        puts @transaction.errors
        render json: @transaction.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @transaction.destroy
      head :no_content
    else
      render json: {transaction: ["can't remove"]}, status: :conflict
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.includes(:period, :budget).where(periods: { budgets: { user: current_user }}).find(params[:transaction_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:value, :comment, :source_id, :destination_id, :transaction_type, :transaction_category_id, :period_id, :date, :budget_id, :type, :target_id)
    end
end

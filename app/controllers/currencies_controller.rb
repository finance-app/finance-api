class CurrenciesController < ApplicationController
  before_action :set_currency, only: [:edit, :destroy, :update, :show]

  def index
    @currencies = Currency.includes(
      :accounts,
      :budgets,
    ).references(:accounts, :budgets).where(user: current_user)
    @transactions = Transaction.includes(:budget).where(periods: {budgets: {user: current_user}}).group("budgets.currency_id").count
    @balances = BalanceBase.where(owner: nil, timeperiod: nil, transaction_type: nil).group(:currency_id, :type).sum(:value)
    @accounts_balances = Balance.where(owner_type: 'Account', timeperiod: nil, transaction_type: nil, currency: Currency.where(user: current_user)).group('currency_id').sum(:value)
  end

  def show
    @balances = BalanceBase.where(owner: nil, timeperiod: nil, transaction_type: nil, currency: @currency).group(:type).sum(:value)

    @budgets = Budget.includes(:default_account).where(user: current_user, currency: @currency)
    @budgets_balances = BalanceBase.where(timeperiod: @budgets, currency: @currency, transaction_type: nil, owner: nil).group(:timeperiod_id, :type).sum(:value)

    @accounts = Account.where(user: current_user, currency: @currency)
    @accounts_balances = BalanceBase.where(owner: @accounts, currency: @currency, timeperiod: nil, transaction_type: nil).group(:owner_id, :type).sum(:value)
  end

  def edit
  end

  # PATCH/PUT /currency/1
  def update
    if @currency.update(currency_params)
      head :no_content, status: :ok
    else
      render json: @currency.errors, status: :unprocessable_entity
    end
  end

  def create
    @currency = Currency.new(currency_params)
    @currency.user = current_user

    if @currency.save
      render json: @currency, status: :created
    else
      render json: @currency.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @currency.destroy
      head :no_content
    else
      render json: {currency: ["can't have any accounts or budgets"]}, status: :conflict
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency
      @currency = Currency.where(user: current_user).find(params[:currency_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def currency_params
      params.require(:currency).permit(:name, :symbol)
    end
end

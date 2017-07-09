class AccountsController < ApplicationController
  before_action :set_account, only: [:edit, :destroy, :update, :correct]

  def index
    @accounts = Account.includes(
      :currency,
    ).where(
      accounts: {
        user: current_user,
        currency: params[:currency_id],
        type: params[:type]
      }.compact
    ).references(:currencies)
    @balances = BalanceBase.where(owner: @accounts, timeperiod: nil, transaction_type: nil).group(:owner_id, :type).sum(:value)

    balances_tmp = Balance.where(owner: @accounts, timeperiod: nil, transaction_type: nil).order('date ASC')
    @balance = {}
    @accounts.each do |account|
      sum = 0
      @balance[account.id] = balances_tmp.select{|a| a.owner_id == account.id}.collect do |b|
        sum += b.value
        {value: sum, date: b.date}
      end
    end
  end

  def balances
    params.permit(:currency_id, :provider, :type, :period_id)
    @accounts = Account.includes(
      :currency,
    ).where(
      accounts: {
        user: current_user,
        currency: params[:currency_id],
        type: params[:type]
      }.compact
    ).references(:currencies)

    if params[:period_id]
      currency = Period.find(params[:period_id]).currency.id
    else
      currency = params[:currency_id]
    end

    # Fetch all balances belonging to requested accounts
    balances_tmp = Balance.where(owner: @accounts, timeperiod: nil, transaction_type: nil, currency_id: currency).order('date ASC')

    precalculated_sums = {}
    # If period ID is defined, try to find it
    if params[:period_id]
      period = Period.where(user: current_user, id: params[:period_id]).first
      # If period is defined, calculate initial sums, which we don't have to graph
      if period
        precalculated_sums = Balance.where(owner: @accounts, timeperiod: nil, transaction_type: nil).where('date < ?', period.start_date).group(:owner_id).sum(:value)

        # Fetch only balances which we are going to graph
        balances_tmp = balances_tmp.where('date >= ?', period.start_date)

        # If period has end date, limit query even further
        if period.end_date
          balances_tmp = balances_tmp.where('date < ?', period.end_date)
        end
      end
    end

    @labels = balances_tmp.map(&:date).uniq

    series_tmp = {
      :savings => {
        :name => 'Savings Total',
        :sum => 0,
        :sums => {},
      },
      :current => {
        :name => 'Current Total',
        :sum => 0,
        :sums => {},
      }
    }

    type_map = {}
    id_map = {}
    first_date = @labels.first

    @accounts.each do |account|
      series_tmp[account.id] = {
        name: account.name,
      }
      series_tmp[account.id][:sum] = precalculated_sums[account.id] || 0
      series_tmp[account.id][:sums] = {}

      series_tmp[account.type][:sum] += precalculated_sums[account.id] || 0
      type_map[account.id] = account.type
      id_map[account.name] = account.id
    end

    balances_tmp.each do |b|
      series_tmp[b.owner_id][:sum] += b.value
      series_tmp[b.owner_id][:sums][b.date] = series_tmp[b.owner_id][:sum]
      series_tmp[type_map[b.owner_id]][:sum] += b.value
      series_tmp[type_map[b.owner_id]][:sums][b.date] = series_tmp[type_map[b.owner_id]][:sum]
    end

    @series = series_tmp.collect do |type, params|
      data = @labels.collect do |date|
        if params[:sums][date]
          params[:sums][date]
        elsif date == first_date
          precalculated_sums[id_map[params[:name]]]
        else
          nil
        end
      end

      {data: data.map{|d| d ? d.to_f : nil }, name: params[:name]}
    end

    # Remove empty series
    @series.delete_if{|s| s[:data].compact.empty?}

    @series.each do |serie|
      if serie[:data][0] == nil
        serie[:data][0] = precalculated_sums[id_map[serie[:name]]].to_f
      end
      if serie[:data].last == nil
        serie[:data][-1] = serie[:data].compact.last
      end
    end
  end

  def show
    @account = Account.includes(:currency).where(user: current_user).find(params[:id])
  end

  def edit
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(accounts_params)
      head :no_content, status: :ok
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def create
    @account = Account.new(accounts_params)
    @account.user = current_user

    if @account.save
      render :show, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @account.destroy
      head :no_content
    else
      render json: {account: ["can't have any associated transactions"]}, status: :conflict
    end
  end

  def correct
    # Require data and value for correction
    params.require(:date)
    params.require(:value)

    @sum_before = Balance.where(owner: @account, timeperiod: nil, transaction_type: nil).where('date < ?', params[:date]).sum(:value)
    @sum_diff = params[:value].to_f - @sum_before
    # Create also Income/Expense?
    ActiveRecord::Base.transaction do
      @balance = Balance.where(owner: @account, timeperiod: nil, transaction_type: nil, date: params[:date]).first_or_initialize(currency: @account.currency, value: 0)
      @old_value = @balance.value
      @balance.value = @sum_diff
      @balance.save!
      @new_balance = Balance.where(owner: @account, timeperiod: nil, transaction_type: nil).where('date > ?', params[:date]).order('date ASC').first
      if @new_balance
        @new_balance.update(value: (@new_balance.value - (@sum_diff - @old_value)))
      end
    end
    head :no_content, status: :ok
  end

  def transfer
    params.require(:source_id)
    params.require(:destination_id)
    params.require(:date)
    params.require(:value)

    if params[:source_id].to_s == params[:destination_id].to_s
      render json: {destination_id: ["can't be the same as source"]}, status: :conflict
    else
      ActiveRecord::Base.transaction do
        [params[:source_id], params[:destination_id]].each do |account|
          value = params[:value].to_f*((account == params[:source_id]) ? -1 : 1)
          account = Account.find(account)

          # Create also Income/Expense?
          balance = Balance.where(owner: account, timeperiod: nil, transaction_type: nil, date: params[:date]).first_or_initialize(currency: account.currency, value: 0)
          balance.value += value
          balance.save!
          new_balance = Balance.where(owner: account, timeperiod: nil, transaction_type: nil).where('date > ?', params[:date]).order('date ASC').first
          if new_balance
            new_balance.update(value: (new_balance.value - value))
          end
        end
      end
      head :no_content, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.where(user: current_user).find(params[:account_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def accounts_params
      params.require(:account).permit(:name, :balance, :currency_id, :comment, :provider, :type)
    end
end

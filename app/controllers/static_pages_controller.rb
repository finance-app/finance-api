class StaticPagesController < ApplicationController
  def overview
    @incomes = Income.where(timeperiod_type: 'Period', timeperiod_id: params[:period_id], owner: nil).where.not(transaction_type: nil).group(:transaction_type).sum(:value)
    @expenses = Expense.where(timeperiod_type: 'Period', timeperiod_id: params[:period_id], owner: nil).where.not(transaction_type: nil).group(:transaction_type).sum(:value)
  end
end

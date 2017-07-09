json.array! @periods do |period|
  json.(period, :id, :name, :comment, :start_date, :end_date)
  json.budget do
    json.(period.budget, :id, :name)
    json.currency do
      json.(period.currency, :id, :name, :symbol)
    end
  end
  json.transactions @transactions[period.id]
  json.incomes_balance @balances[[period.id, 'Income']]
  json.expenses_balance @balances[[period.id, 'Expense']]
  json.balance @balances[[period.id, 'Balance']]
end

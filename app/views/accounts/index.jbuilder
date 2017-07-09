json.array! @accounts do |account|
  json.(account, :id, :name, :comment, :type, :provider, :model_name)
  json.currency do
    json.(account.currency, :id, :name, :symbol)
  end
  json.incomes_balance @balances[[account.id, 'Income']]
  json.expenses_balance @balances[[account.id, 'Expense']]
  json.balance @balances[[account.id, 'Balance']]
  json.balances @balance[account.id]
end

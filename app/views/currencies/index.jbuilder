json.array! @currencies do |currency|
  json.(currency, :id, :name, :symbol)
  json.budgets currency.budgets.size
  json.accounts currency.accounts.size
  json.transactions @transactions[currency.id]
  json.incomes_balance @balances[[currency.id, 'Income']]
  json.expenses_balance @balances[[currency.id, 'Expense']]
  json.balance @balances[[currency.id, 'Balance']]
  json.accounts_balance @accounts_balances[currency.id]
end

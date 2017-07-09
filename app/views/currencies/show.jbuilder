json.(@currency, :id, :name, :symbol)

json.incomes_balance @balances['Income']
json.expenses_balance @balances['Expense']
json.balance @balances['Balance']

json.budgets @budgets do |budget|
  json.(budget, :id, :name, :comment)
  if budget.default_account
    json.default_account do
      json.(budget.default_account, :id, :name)
    end
  end
  json.currency do
    json.(@currency, :id, :name, :symbol)
  end
  json.incomes_balance @budgets_balances[[budget.id, 'Income']]
  json.expenses_balance @budgets_balances[[budget.id, 'Expense']]
  json.balance @budgets_balances[[budget.id, 'Balance']]
end

json.accounts @accounts do |account|
  json.(account, :id, :name, :comment, :type, :provider)
  json.currency do
    json.(@currency, :id, :name, :symbol)
  end
  json.incomes_balance @accounts_balances[[account.id, 'Income']]
  json.expenses_balance @accounts_balances[[account.id, 'Expense']]
  json.balance @accounts_balances[[account.id, 'Balance']]
end

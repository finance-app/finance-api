json.(@budget, :id, :name, :comment)

json.incomes_balance @balances['Income']
json.expenses_balance @balances['Expense']
json.balance @balances['Balance']

json.currency do
  json.(@budget.currency, :id, :name, :symbol)
end

if @budget.default_account
  json.default_account do
    json.(@budget.default_account, :id, :name)
  end
end

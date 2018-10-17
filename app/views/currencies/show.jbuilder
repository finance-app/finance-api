json.(@currency, :id, :name, :symbol)

json.incomes_balance @balances['Income']
json.expenses_balance @balances['Expense']
json.balance @balances['Balance']

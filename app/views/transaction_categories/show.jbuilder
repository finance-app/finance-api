json.(@transaction_category, :id, :name, :comment)
json.incomes_balance @balances['Income']
json.expenses_balance @balances['Expense']
json.balance @balances['Balance']

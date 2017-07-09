json.(@target, :id, :name, :comment, :favourite)

json.incomes_balance @balances['Income']
json.expenses_balance @balances['Expense']
json.balance @balances['Balance']

if @target.default_income_transaction_category
  json.default_income_transaction_category do
    json.(@target.default_income_transaction_category, :id, :name)
  end
end
if @target.default_expense_transaction_category
  json.default_expense_transaction_category do
    json.(@target.default_expense_transaction_category, :id, :name)
  end
end

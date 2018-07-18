json.array! @targets do |target|
  json.(target, :id, :name, :comment, :model_name, :favourite)
  if target.default_income_transaction_category
    json.default_income_transaction_category do
      json.(target.default_income_transaction_category, :id, :name)
    end
  end
  if target.default_expense_transaction_category
    json.default_expense_transaction_category do
      json.(target.default_expense_transaction_category, :id, :name)
    end
  end
  json.transactions @incomes_transactions[target.id].to_i + @expenses_transactions[target.id].to_i
  json.incomes_balance @balances[[target.id, 'Income']]
  json.expenses_balance @balances[[target.id, 'Expense']]
  json.balance @balances[[target.id, 'Balance']]
  json.budgets target.budgets do |budget|
    json.(budget, :id, :name)
    json.currency do
      json.(budget.currency, :id, :name, :symbol)
    end
  end
end

json.array! @budgets do |budget|
  json.(budget, :id, :name, :comment)
  if budget.default_account
    json.default_account do
      json.(budget.default_account, :id, :name)
    end
  end
  json.currency do
    json.(budget.currency, :id, :name, :symbol)
  end
  json.incomes_balance @balances[[budget.id, 'Income']]
  json.expenses_balance @balances[[budget.id, 'Expense']]
  json.balance @balances[[budget.id, 'Balance']]
end

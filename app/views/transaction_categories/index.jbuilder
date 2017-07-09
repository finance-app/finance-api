json.array! @transaction_categories do |transaction_category|
  json.(transaction_category, :id, :name, :comment)

  json.incomes_balance @balances[[transaction_category.id, 'Income']]
  json.expenses_balance @balances[[transaction_category.id, 'Expense']]
  json.balance @balances[[transaction_category.id, 'Balance']]
  json.transactions transaction_category.transactions.size
end

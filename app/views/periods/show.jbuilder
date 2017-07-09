# Period
json.(@period, :id, :name, :comment, :start_date, :end_date, :balance_history)
json.incomes_balance @balances['Income']
json.expenses_balance @balances['Expense']
json.balance @balances['Balance']

# Budget with currency
json.budget do
  json.(@period.budget, :id, :name)
  json.currency do
    json.(@period.currency, :id, :name, :symbol)
  end
end

json.transactions @transactions do |transaction|
  json.(transaction, :id, :value, :comment, :date)

  json.period do
    json.(@period, :id, :name)
  end

  json.budget do
    json.(@period.budget, :id, :name)
  end

  json.transaction_category do
    json.(transaction.transaction_category, :id, :name)
  end

  if transaction.source_id and
    json.source do
      if transaction.source_type == 'Target'
        a = @targets.select{|t| t[0] == transaction.source_id}.first
      else
        a = @accounts.select{|t| t[0] == transaction.source_id}.first
      end
      json.id a[0]
      json.name a[1]
      json.model_name transaction.source_type
    end
  end

  if transaction.destination_id
    json.destination do
      if transaction.destination_type == 'Target'
        a = @targets.select{|t| t[0] == transaction.destination_id}.first
      else
        a = @accounts.select{|t| t[0] == transaction.destination_id}.first
      end
      json.id a[0]
      json.name a[1]
      json.model_name transaction.destination_type
    end
  end
end

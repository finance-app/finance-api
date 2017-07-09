json.(@account, :id, :name, :comment, :type, :provider, :incomes_balance, :expenses_balance, :balance)
json.currency do
  json.(@account.currency, :id, :name, :symbol)
end

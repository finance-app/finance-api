json.(@transaction, :id, :value, :date, :comment, :type)

json.period do
  json.(@transaction.period, :id, :name)
end

json.budget do
  json.(@transaction.budget, :id, :name)
end

json.transaction_category do
  json.(@transaction.transaction_category, :id, :name)
end

json.source do
  json.(@transaction.source, :id, :name, :model_name)
end if @transaction.source

json.destination do
  json.(@transaction.destination, :id, :name, :model_name)
end if @transaction.destination


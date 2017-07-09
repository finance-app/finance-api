json.array! @transactions do |transaction|
  json.(transaction, :id, :value, :date, :comment, :type)

  json.period do
    json.(transaction.period, :id, :name)
  end

  json.budget do
    json.(transaction.budget, :id, :name)
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

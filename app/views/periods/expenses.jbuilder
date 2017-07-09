json.series [
  {
    data: @flexible_expenses.map{|a| a.to_f},
    name: 'Flexible expenses',
  },
  {
    data: @discretionary_expenses.map{|a| a.to_f},
    name: 'Discretionary expenses',
    visible: false,
  }
]
json.labels @dates

class AddDateToExpenses < ActiveRecord::Migration[5.1]
  def change
    add_column :expenses, :date, :date
    change_column_null :expenses, :date, false
  end
end

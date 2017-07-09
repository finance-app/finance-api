class AddDateToIncomes < ActiveRecord::Migration[5.1]
  def change
    add_column :incomes, :date, :date
    change_column_null :incomes, :date, false
  end
end

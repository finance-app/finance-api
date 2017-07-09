class DropExpensesAndIncomes < ActiveRecord::Migration[5.1]
  def change
    drop_table :incomes
    drop_table :expenses
  end
end

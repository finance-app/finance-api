class AddDateToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :date, :date
    change_column_null :transactions, :date, false
  end
end

class AddDateToBalances < ActiveRecord::Migration[5.1]
  def change
    add_column :balances, :date, :date
    change_column_null :balances, :date, false
  end
end

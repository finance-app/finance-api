class UpdateBalanceTable < ActiveRecord::Migration[5.1]
  def change
    change_column_null :balances, :timeperiod_type, true
    change_column_null :balances, :timeperiod_id, true
    change_column_null :balances, :owner_type, true
    change_column_null :balances, :owner_id, true
  end
end

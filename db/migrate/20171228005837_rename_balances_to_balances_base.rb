class RenameBalancesToBalancesBase < ActiveRecord::Migration[5.1]
  def change
    rename_table :balances, :balance_bases
  end
end

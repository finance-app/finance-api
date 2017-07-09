class AddTypeToBalance < ActiveRecord::Migration[5.1]
  def change
    add_column :balances, :type, :string
    change_column_null :balances, :type, false
  end
end

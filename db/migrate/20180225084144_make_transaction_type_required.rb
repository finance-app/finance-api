class MakeTransactionTypeRequired < ActiveRecord::Migration[5.1]
  def change
    change_column :transactions, :type, :string, null: false
  end
end

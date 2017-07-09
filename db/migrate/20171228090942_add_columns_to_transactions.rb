class AddColumnsToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :budget, index: true
    add_reference :transactions, :user, index: true
  end
end

class UpdateTypeForAllTransactions < ActiveRecord::Migration[5.1]
  def change
    Transaction.update_all(type: 'flexible')
  end
end

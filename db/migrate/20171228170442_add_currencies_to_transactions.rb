class AddCurrenciesToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :source_currency, index: true
    add_reference :transactions, :destination_currency, index: true
  end
end

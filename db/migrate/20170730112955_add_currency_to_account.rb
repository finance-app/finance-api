class AddCurrencyToAccount < ActiveRecord::Migration[5.1]
  def change
    add_reference :accounts, :currency, index: true
    change_column_null :accounts, :currency_id, false
  end
end

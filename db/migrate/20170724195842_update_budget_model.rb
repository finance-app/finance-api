class UpdateBudgetModel < ActiveRecord::Migration[5.1]
  def change
    change_column_null :budgets, :name, false

    remove_column :budgets, :currency

    remove_column :budgets, :currency_symbol

    change_column_null :budgets, :user_id, false

    add_reference :budgets, :default_account, index: true

    add_reference :budgets, :currency, index: true
    change_column_null :budgets, :currency_id, false

    add_column :budgets, :comment, :string

    add_column :budgets, :active, :boolean, :null => false, :default => true

  end
end

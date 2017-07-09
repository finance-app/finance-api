class UpdateTargetModel < ActiveRecord::Migration[5.1]
  def change
    change_column_null :targets, :name, false
    remove_column :targets, :budget_id
    remove_column :targets, :default_account_id

    add_reference :targets, :user, index: true
    change_column_null :targets, :user_id, false
    add_reference :targets, :default_income_transaction_category, index: true
    add_reference :targets, :default_expense_transaction_category, index: true
  end
end

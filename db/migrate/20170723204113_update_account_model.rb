class UpdateAccountModel < ActiveRecord::Migration[5.1]
  def change
    change_column_null :accounts, :name, false
    remove_column :accounts, :balance
    remove_column :accounts, :target_id
    add_column :accounts, :provider, :string, :null => false, :default => 'plain'
    add_column :accounts, :type, :string, :null => false, :default => 'current'
    add_column :accounts, :user_id, :integer
    change_column_null :accounts, :user_id, false
  end
end

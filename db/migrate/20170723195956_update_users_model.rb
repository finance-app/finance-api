class UpdateUsersModel < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string, :null => true
    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false
  end
end

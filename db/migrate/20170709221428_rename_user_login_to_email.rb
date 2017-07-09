class RenameUserLoginToEmail < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :login, :email
  end
end

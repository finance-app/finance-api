class RenameUserNameToLogin < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :name, :login
  end
end

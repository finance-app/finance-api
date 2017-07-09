class AddMissingIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :accounts, :user_id
  end
end

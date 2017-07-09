class CreateTargets < ActiveRecord::Migration[5.1]
  def change
    create_table :targets do |t|
      t.string :name
      t.string :comment
      t.integer :budget_id
      t.integer :default_account_id

      t.timestamps
    end
  end
end

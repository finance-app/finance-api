class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.decimal :balance, precision: 8, scale: 2
      t.string :comment

      t.timestamps
    end
  end
end

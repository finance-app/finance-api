class CreateTransactionCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :transaction_categories do |t|
      t.string :name, null: false
      t.string :comment
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end

class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :period, foreign_key: true, null: false
      t.references :transaction_category, foreign_key: true, null: false
      t.decimal :currency_rate, null: false, default: 1.0
      t.string :comment
      t.decimal :value, precision: 8, scale: 2, null: false
      t.references :source, polymorphic: true
      t.references :destination, polymorphic: true

      t.timestamps
    end
  end
end

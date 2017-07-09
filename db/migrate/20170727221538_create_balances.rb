class CreateBalances < ActiveRecord::Migration[5.1]
  def change
    create_table :balances do |t|
      t.references :timeperiod, polymorphic: true, null: false
      t.references :owner, polymorphic: true
      t.references :currency, foreign_key: true, null: false
      t.decimal :value, precision: 8, scale: 2, null: false, default: 0.0

      t.timestamps
    end
  end
end

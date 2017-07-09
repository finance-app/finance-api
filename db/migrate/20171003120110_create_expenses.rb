class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.references :timeperiod, polymorphic: true, null: true
      t.references :owner, polymorphic: true, null: true
      t.references :currency, foreign_key: true, null: true
      t.decimal :value, precision: 8, scale: 2, null: false, default: 0.0

      t.timestamps
    end
  end
end

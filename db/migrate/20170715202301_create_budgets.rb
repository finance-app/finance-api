class CreateBudgets < ActiveRecord::Migration[5.1]
  def change
    create_table :budgets do |t|
      t.string :name
      t.string :currency
      t.string :currency_symbol
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

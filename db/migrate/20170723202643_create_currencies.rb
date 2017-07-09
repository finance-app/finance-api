class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :name, null: false
      t.string :symbol, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end

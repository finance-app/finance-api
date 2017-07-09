class CreatePeriods < ActiveRecord::Migration[5.1]
  def change
    create_table :periods do |t|
      t.references :budget, foreign_key: true, null: false
      t.string :comment
      t.date :start_date, null: false
      t.date :end_date

      t.timestamps
    end
  end
end

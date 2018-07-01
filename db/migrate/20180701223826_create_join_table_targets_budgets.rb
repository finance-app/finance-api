class CreateJoinTableTargetsBudgets < ActiveRecord::Migration[5.2]
  def change
    create_join_table :targets, :budgets do |t|
      # t.index [:target_id, :budget_id]
      # t.index [:budget_id, :target_id]
    end
  end
end

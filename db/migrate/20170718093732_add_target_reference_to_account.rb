class AddTargetReferenceToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :target_id, :integer
  end
end

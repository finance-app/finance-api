class AddMissingIndexesToBalanceBases < ActiveRecord::Migration[5.1]
  def change
    add_index :balance_bases, [:id, :type]
  end
end

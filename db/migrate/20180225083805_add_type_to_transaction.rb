class AddTypeToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :type, :string
  end
end

class AddFavouriteToTargets < ActiveRecord::Migration[5.1]
  def change
    add_column :targets, :favourite, :boolean, default: false
  end
end

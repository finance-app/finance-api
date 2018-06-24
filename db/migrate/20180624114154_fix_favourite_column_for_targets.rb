class FixFavouriteColumnForTargets < ActiveRecord::Migration[5.1]
  def change
    Target.where(favourite: nil).update_all(favourite: false)
  end
end

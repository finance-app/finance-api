class AddUserToPeriods < ActiveRecord::Migration[5.1]
  def change
    add_reference :periods, :user, index: true
  end
end

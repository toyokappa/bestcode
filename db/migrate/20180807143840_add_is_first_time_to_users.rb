class AddIsFirstTimeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_first_time, :boolean, null: false, default: true
  end
end

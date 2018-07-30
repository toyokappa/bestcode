class AddIsOpenToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :is_open, :boolean, null: false, default: true
  end
end

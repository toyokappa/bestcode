class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :description
      t.integer :capacity
      t.references :reviewer

      t.timestamps
    end
    add_foreign_key :rooms, :users, column: :reviewer_id
  end
end

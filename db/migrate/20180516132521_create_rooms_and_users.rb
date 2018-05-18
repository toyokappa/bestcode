class CreateRoomsAndUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :description
      t.integer :capacity
      t.references :reviewer

      t.timestamps
    end
    add_foreign_key :rooms, :users, column: :reviewer_id

    create_table :rooms_users, id: false do |t|
      t.belongs_to :room, index: true
      t.belongs_to :user, index: true
    end
  end
end

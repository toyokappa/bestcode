class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.integer :contribution, default: 0, null: false
      t.string :role, default: "reviewee", null: false
      t.string :access_token
      t.string :image
      t.string :header_image
      t.boolean :is_first_time, null: false, default: true

      t.timestamps
    end
  end
end

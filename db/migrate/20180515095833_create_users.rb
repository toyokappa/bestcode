class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.integer :contribution, default: 0, null: false
      t.boolean :is_reviewer, default: false, null: false

      t.timestamps
    end
  end
end

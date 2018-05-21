class CreatePullRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :pull_requests do |t|
      t.string :name
      t.text :description
      t.string :url
      t.integer :number
      t.boolean :is_open, default: false, null: false
      t.references :repository, foreign_key: true

      t.timestamps
    end
  end
end

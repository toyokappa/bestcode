class CreatePulls < ActiveRecord::Migration[5.2]
  def change
    create_table :pulls do |t|
      t.string :name
      t.text :description
      t.string :url
      t.integer :number
      t.boolean :is_open, default: false, null: false
      t.references :repo, foreign_key: true

      t.timestamps
    end
  end
end

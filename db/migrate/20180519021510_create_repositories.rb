class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :full_name
      t.text :description
      t.string :url
      t.boolean :is_privarte, default: false, null: false
      t.boolean :is_visible, default: false, null: false
      t.references :user, foreign_key: true
      t.datetime :pushed_at

      t.timestamps
    end
  end
end

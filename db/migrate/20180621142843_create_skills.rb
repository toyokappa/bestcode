class CreateSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :skills do |t|
      t.integer :language_id
      t.references :languageable, polymorphic: true, index: true
      t.timestamps
    end
  end
end

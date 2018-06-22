class CreateSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :skills do |t|
      t.references :language, index: true
      t.references :languageable, polymorphic: true, index: true
      t.timestamps
    end
  end
end

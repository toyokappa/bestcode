class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.integer :speed, null: false, default: 3
      t.integer :quantity, null: false, default: 3
      t.integer :quality, null: false, default: 3
      t.text :comment
      t.belongs_to :reviewee, index: true
      t.belongs_to :room, index: true

      t.timestamps
    end
  end
end

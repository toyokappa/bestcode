class CreateParticipations < ActiveRecord::Migration[5.2]
  def change
    create_table :participations do |t|
      t.belongs_to :participating_room, index: true
      t.belongs_to :reviewee, index: true

      t.timestamps
    end
  end
end

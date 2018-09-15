class CreateReviewRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :review_requests do |t|
      t.string :name
      t.boolean :is_open, default: true, null: false
      t.string :state, default: "wait_review", null: false
      t.integer :pull_id, index: true
      t.integer :reviewee_id, index: true
      t.integer :room_id, index: true

      t.timestamps
    end
  end
end

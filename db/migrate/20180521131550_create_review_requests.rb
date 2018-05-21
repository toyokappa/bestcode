class CreateReviewRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :review_requests do |t|
      t.string :name
      t.text :description
      t.boolean :is_open, default: true, null: false
      t.integer :state, default: 0, null: false
      t.integer :pull_request_id, index: true
      t.integer :reviewee_id, index: true
      t.integer :reviewer_id, index: true

      t.timestamps
    end
  end
end

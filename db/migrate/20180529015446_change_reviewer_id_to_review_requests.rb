class ChangeReviewerIdToReviewRequests < ActiveRecord::Migration[5.2]
  def up
    rename_column :review_requests, :reviewer_id, :room_id
  end

  def down
    rename_column :review_requests, :room_id, :reviewer_id
  end
end

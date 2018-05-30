class RenamePullRequestsToPulls < ActiveRecord::Migration[5.2]
  def change
    rename_table :pull_requests, :pulls
    rename_column :review_requests, :pull_request_id, :pull_id
  end
end

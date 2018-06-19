class ChangeIntegerToStringForEnum < ActiveRecord::Migration[5.2]
  def up
    change_column :review_requests, :state, :string, null: false, default: "wait_review"
  end

  def down
    change_column :review_requests, :state, :integer, null: false, default: 0
  end
end

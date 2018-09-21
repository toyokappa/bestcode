class AddNoticedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :noticed_at, :datetime
  end
end

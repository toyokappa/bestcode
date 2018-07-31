class AddIsHookToRepos < ActiveRecord::Migration[5.2]
  def change
    add_column :repos, :is_hook, :boolean, null: false, default: false
  end
end

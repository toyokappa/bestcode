class RenameRepositoriesToRepos < ActiveRecord::Migration[5.2]
  def change
    rename_table :repositories, :repos
    rename_column :pull_requests, :repository_id, :repo_id
  end
end

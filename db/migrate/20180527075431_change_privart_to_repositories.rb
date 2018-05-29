class ChangePrivartToRepositories < ActiveRecord::Migration[5.2]
  def up
    rename_column :repositories, :is_privarte, :is_private
  end

  def down
    rename_column :repositories, :is_private, :is_privarte
  end
end

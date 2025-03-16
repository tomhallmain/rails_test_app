class AddArchiveIndexToTasks < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :tasks, :archived, algorithm: :concurrently
    add_index :tasks, :archived_at, algorithm: :concurrently
  end
end 
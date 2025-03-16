class AddTaskIndexes < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :tasks, :completed_by, algorithm: :concurrently
    add_index :comments, :status, algorithm: :concurrently
    add_index :tasks, [:completed, :due_date], algorithm: :concurrently
    add_index :tasks, [:project_id, :completed], algorithm: :concurrently
  end
end 
class AddForeignKeyToTasks < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :tasks, :users, column: :completed_by, validate: false
  end
end 
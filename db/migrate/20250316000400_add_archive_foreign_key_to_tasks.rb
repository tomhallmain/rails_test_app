class AddArchiveForeignKeyToTasks < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :tasks, :users, column: :archived_by, validate: false
  end
end 
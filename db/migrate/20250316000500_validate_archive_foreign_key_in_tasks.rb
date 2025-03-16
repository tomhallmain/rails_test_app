class ValidateArchiveForeignKeyInTasks < ActiveRecord::Migration[8.0]
  def change
    validate_foreign_key :tasks, :users, column: :archived_by
  end
end 
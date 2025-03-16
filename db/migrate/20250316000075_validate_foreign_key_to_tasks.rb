class ValidateForeignKeyToTasks < ActiveRecord::Migration[8.0]
  def change
    validate_foreign_key :tasks, :users
  end
end 
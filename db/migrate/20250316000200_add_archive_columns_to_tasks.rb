class AddArchiveColumnsToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :archived, :boolean, default: false, null: false
    add_column :tasks, :archived_at, :datetime
    add_column :tasks, :archived_by, :integer
  end
end 
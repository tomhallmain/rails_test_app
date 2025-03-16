class AddCompletionFieldsToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :completed_at, :datetime
    add_column :tasks, :completed_by, :integer
    
    # Add status to comments for tracking resolved state
    add_column :comments, :status, :string, default: 'open'
  end
end 
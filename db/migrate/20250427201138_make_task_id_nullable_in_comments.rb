class MakeTaskIdNullableInComments < ActiveRecord::Migration[7.1]
  def change
    change_column_null :comments, :task_id, true
  end
end

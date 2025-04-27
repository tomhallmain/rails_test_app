class AddProjectIdToComments < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_reference :comments, :project, null: true, index: {algorithm: :concurrently}
  end
end

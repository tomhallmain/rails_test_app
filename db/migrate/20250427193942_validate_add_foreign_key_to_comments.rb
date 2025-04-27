class ValidateAddForeignKeyToComments < ActiveRecord::Migration[8.0]
  def change
    validate_foreign_key :comments, :projects
  end
end

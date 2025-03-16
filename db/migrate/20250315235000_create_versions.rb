class CreateVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :versions do |t|
      t.string   :item_type,   null: false
      t.bigint   :item_id,     null: false
      t.string   :event,       null: false
      t.string   :whodunnit    # user ID
      t.text     :object       # previous version of the object
      t.text     :object_changes # what changed in this version
      t.datetime :created_at
      t.string   :ip          # custom metadata
      t.string   :user_agent  # custom metadata
    end
    add_index :versions, %i[item_type item_id]
  end
end 
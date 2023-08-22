class RemoveForeignKeysFromRevisions < ActiveRecord::Migration[6.0]  # NOTE: Adjust the Rails version if it's different in your app
  def change
    # Removing foreign key constraints
    remove_foreign_key :revisions, :users
    remove_foreign_key :revisions, :posts
  end
end

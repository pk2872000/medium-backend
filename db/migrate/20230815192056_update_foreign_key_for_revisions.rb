class UpdateForeignKeyForRevisions < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :revisions, :posts
    add_foreign_key :revisions, :posts, on_delete: :cascade
  end
end

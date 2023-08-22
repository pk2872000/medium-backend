class CreateRevisions < ActiveRecord::Migration[6.0]  # NOTE: Your Rails version might be different than 6.0
  def change
    create_table :revisions do |t|
      t.string :action
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :topic
      t.text :content
      t.string :status

      t.timestamps
    end
  end
end

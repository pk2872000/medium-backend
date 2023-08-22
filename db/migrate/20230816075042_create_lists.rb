class CreateLists < ActiveRecord::Migration[6.0] # or whatever your current Rails version is
  def change
    create_table :lists do |t|
      t.string :list_name
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end

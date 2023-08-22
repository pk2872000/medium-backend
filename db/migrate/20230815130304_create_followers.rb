class CreateFollowers < ActiveRecord::Migration[6.0]
  def change
    create_table :followers do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :followers, [:follower_id, :followed_id], unique: true
  end
end

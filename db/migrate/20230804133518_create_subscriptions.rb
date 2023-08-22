class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.decimal :price
      t.integer :max_posts_per_day

      t.timestamps
    end
  end
end

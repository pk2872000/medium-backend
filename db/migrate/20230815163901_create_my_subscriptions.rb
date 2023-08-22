class CreateMySubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :my_subscriptions do |t|
      t.references :user, foreign_key: true
      t.integer :amount_id
      
      t.timestamps
    end
  end
end

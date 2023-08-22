class CreateRemainingAttempts < ActiveRecord::Migration[7.0]
  def change
    create_table :remaining_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :attempts, default: 0, null: false

      t.timestamps
    end
  end
end

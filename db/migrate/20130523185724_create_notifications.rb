class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :stage_id
      t.string :condition
      t.integer :count

      t.timestamps
    end
  end
end

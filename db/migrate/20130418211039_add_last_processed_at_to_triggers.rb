class AddLastProcessedAtToTriggers < ActiveRecord::Migration

  def change
    add_column :triggers, :last_processed_at, :datetime
  end

end

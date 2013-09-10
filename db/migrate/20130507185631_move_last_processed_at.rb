class MoveLastProcessedAt < ActiveRecord::Migration

	def change
		add_column :statuses, :last_processed_at, :datetime
		remove_column :triggers, :last_processed_at
	end

end

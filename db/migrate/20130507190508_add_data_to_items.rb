class AddDataToItems < ActiveRecord::Migration

	def change
		add_column	:items, :data, :text
	end

end

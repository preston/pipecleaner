class AddNotesToStatuses < ActiveRecord::Migration
  def change
  	add_column :statuses, :notes, :text
  end
end

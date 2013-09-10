class ChangeTriggersTable < ActiveRecord::Migration

  def change
  	add_column		:triggers,	:service_id,	:integer
  	remove_column	:triggers,	:url
  	remove_column	:triggers,	:verb
  end
 
end

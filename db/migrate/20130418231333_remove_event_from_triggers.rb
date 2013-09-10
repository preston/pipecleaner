class RemoveEventFromTriggers < ActiveRecord::Migration

  def change
        remove_column   :triggers, :event
  end
 
end

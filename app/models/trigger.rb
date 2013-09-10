class Trigger < ActiveRecord::Base

	belongs_to	:stage, inverse_of: :triggers
	belongs_to	:service

	ALL_CONDITIONS = Status::ALL

	validates_presence_of	:stage
	validates_presence_of	:service
	validates_presence_of	:condition

	validates :condition, :inclusion => {:in => ALL_CONDITIONS}

	attr_accessible :stage, :service, :stage_id, :service_id, :condition, :event

	def run(status)
		if status.last_processed_at.nil? || (status.updated_at.time > status.last_processed_at.time)
			# We've either never run, or haven't run since the last update, so let's do it!
			service.notify(status, self)
		else
			# We already called the service, so fuhgettaboutit
		end
	end

end

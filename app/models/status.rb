class Status < ActiveRecord::Base
	
	belongs_to	:member
	belongs_to	:stage

	belongs_to	:user,	foreign_key: :created_by


	COMPLETE = 'complete'
	WARNING = 'warning'
	DANGER = 'danger'
	PENDING = 'pending'
	SKIPPED = 'skipped'
	DEFAULT = 'default'
	ALL = [COMPLETE, WARNING, DANGER, PENDING, SKIPPED, DEFAULT]
	COLORS = {
		COMPLETE => 'green',
		WARNING => 'yellow',
		DANGER => 'red',
		PENDING => 'blue',
		SKIPPED => '#555',
		DEFAULT => '#aaa'
	}

	validates :code, :inclusion => {:in => ALL}
	validates_presence_of	:code
	validates_presence_of	:member
	validates_presence_of	:stage
	validates_presence_of	:user

	attr_accessible :member, :member_id, :stage, :stage_id, :code, :user, :created_by, :notes

	after_save	:touch_member
	after_save	:enqueue_triggers
	after_save	:enqueue_notifications

	def touch_member
		member.touch
		true
	end

	def enqueue_triggers
		# puts "Searching for triggers to enqueue for condition '#{self.code}'."
		stage.triggers.each do |t|
			if(t.condition == self.code)
				# puts "Enqueueing trigger for #{t.service.name} (Trigger ID: #{t.id})"
				t.delay.run(self)
			else
				# Stage state doesn't match, so don't do it!
			end
		end
		true
	end

	def enqueue_notifications
		stage.notifications.each do |n|
			if(n.condition == self.code)
				Notifications.delay.status_change(n, self)
			else
				# Notification doesn't match condition, so don't worry about it!
			end
		end
	end

end

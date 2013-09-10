class Notification < ActiveRecord::Base

	belongs_to	:user
	belongs_to	:stage

	validates_presence_of	:user
	validates_presence_of	:stage
	validates_presence_of	:condition

	# validates_numericality_of	:count, only_integer: true, min: 0

	attr_accessible :condition, :stage_id, :user_id, :count

end

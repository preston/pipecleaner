class Favorite < ActiveRecord::Base

	belongs_to	:user
	belongs_to	:member

	validates_presence_of	:user
	validates_presence_of	:member

	validates_uniqueness_of	:user_id, scope: [:member_id]

	attr_accessible :member_id, :user_id
end

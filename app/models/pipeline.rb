class Pipeline < ActiveRecord::Base

	extend FriendlyId
	friendly_id	:code, use: :slugged

	has_many	:stages,	dependent: :destroy
	has_many	:members,	dependent: :destroy

	has_many	:items,	through: :members

	belongs_to	:user,	foreign_key: :created_by

	validates_presence_of	:name
	validates_presence_of	:description
	validates_presence_of	:code
	validates_presence_of	:user

	validates_uniqueness_of	:name
	validates_uniqueness_of	:code
	
	attr_accessible :code, :description, :name, :user

	def statistics
		stats = {}
		self.stages.rank(:number).each do |s|
			members = {}
			Status::ALL.each do |name|
				members[name] = []
			end
			self.members.each do |m|
				status = s.statuses.find {|stat| stat.member == m}
				# status = Status.where(member_id: m.id, stage_id: s.id).first
				if status.nil?
					members[Status::DEFAULT] << m
				else
					members[status.code] << m
				end
			end
			stats[s.name] = members
		end
		stats
	end

end

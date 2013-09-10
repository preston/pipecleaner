class Item < ActiveRecord::Base

	acts_as_taggable
	acts_as_taggable_on	:projects

	has_many	:members,	dependent: :destroy
	has_many	:pipelines,	through: :members
	belongs_to	:user,	foreign_key: :created_by

	validates_presence_of	:user
	validates_presence_of	:name
	validates_uniqueness_of	:name

	attr_accessible :name, :notes, :user, :project_list

	before_save :default_values

	def default_values
		self.data = '{}' if self.data.nil? || self.data == ''
	end

end

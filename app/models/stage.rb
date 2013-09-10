class Stage < ActiveRecord::Base

	extend FriendlyId
	friendly_id	:name, use: :slugged

	# Uses the ranked-model gem.
	include RankedModel
	ranks :number, with_same: :pipeline_id

	belongs_to	:pipeline

	has_many	:statuses,		dependent: :destroy
	has_many	:triggers,		dependent: :destroy, :before_add => :set_nest
	has_many	:notifications,	dependent: :destroy

	accepts_nested_attributes_for	:triggers, allow_destroy: true

	validates_presence_of	:pipeline
	validates_numericality_of	:number, only_integer: true, greater_than_or_equal_to: 0
	validates_uniqueness_of	:name,	scope: [:pipeline_id]

	attr_accessible :pipeline, :description, :name, :pipeline_id, :number, :triggers_attributes


	private

	# http://stackoverflow.com/questions/2611459/ruby-on-rails-nested-attributes-how-do-i-access-the-parent-model-from-child-m
	def set_nest(trigger)
		trigger.stage ||= self
	end

end

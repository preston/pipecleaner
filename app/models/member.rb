class Member < ActiveRecord::Base

	belongs_to	:pipeline
	belongs_to	:item

	has_many	:statuses,		dependent: :destroy
	has_many 	:favorites,		dependent: :destroy

	validates_presence_of	:pipeline
	validates_presence_of	:item

	# Items can only belong to a given pipeline once.
	validates_uniqueness_of	:pipeline_id, scope: [:item_id]


	attr_accessible :item_id, :pipeline_id

	scope	:active,	where(archived: false)
	scope	:archived,	where(archived: true)

end

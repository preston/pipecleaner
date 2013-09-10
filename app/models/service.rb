
class Service < ActiveRecord::Base

	has_many	:triggers,	dependent: :destroy

	validates_presence_of	:name
	validates_presence_of	:url
	validates_presence_of	:verb

	validates_uniqueness_of	:name

	VERB_GET	= 'GET'
	VERB_HEAD	= 'HEAD'
	VERB_POST	= 'POST'
	VERB_PUT	= 'PUT'
	VERB_DELETE	= 'DELETE'

	ALLOWED_VERBS = [VERB_GET, VERB_HEAD, VERB_POST, VERB_PUT, VERB_DELETE]

	validates :verb, :inclusion => {:in => ALLOWED_VERBS}


	attr_accessible :include_basic, :include_data, :include_extended, :name, :url, :verb

	def notify(status, trigger = nil)
		resp = nil
		stage = status.stage

		# Sanity check the current conditions
		if trigger && trigger.condition == status.code
			payload = {}
			if self.include_basic
				stages = stage.pipeline.stages.sort{|a,b| a.number <=> b.number}
				previous = stages[stage.number - 1]
				current = stages[stage.number]
				nex = stages[stage.number + 1]
				payload[:status] = JSON.parse status.to_json(include: [:member, :stage])
				payload[:stage_name] = current.name
				payload[:item_name] = status.member.item.name
				payload[:pipeline_code] = stage.pipeline.code
				payload[:pipeline_name] = stage.pipeline.name
				payload[:previous_stage_id] = previous.id unless previous.nil?
				payload[:previous_stage_name] = previous.name unless previous.nil?
				payload[:next_stage_id] = nex.id unless nex.nil?
				payload[:next_stage_name] = nex.name unless nex.nil?
			end
			if self.include_extended
				payload[:member] = JSON.parse status.member.to_json(include: [:statuses, :item])
				payload[:pipeline] = JSON.parse status.stage.pipeline.to_json(include: [:stages])
			end
			if self.include_data
				data = {}
				begin
					data = JSON.parse(status.member.item.data)
				rescue
					puts "BUG: Why is there bad JSON in the database!?!?"
				end
				payload[:data] = data
			end
			h = {'Content-Type' => 'application/json'}
			body = payload.to_json
			puts "SENDING\n#{body}"
			case self.verb
			when VERB_GET
				resp = HTTParty.get(url, :body => body, headers: h)			
			when VERB_HEAD
				resp = HTTParty.head(url, :body => body, headers: h)			
			when VERB_POST
				resp = HTTParty.post(url, :body => body, headers: h)			
			when VERB_PUT
				resp = HTTParty.put(url, :body => body, headers: h)			
			when VERB_DELETE
				resp = HTTParty.delete(url, :body => body, headers: h)			
			end
		else
			# Either the trigger is not known, or the condition no longer matcher the applicable status code.
			# This can happen legitimately in the case where the status is updated multiple times in rapid succession
			# before asynchronous trigger processing jobs kick in.
		end

		resp
	end

end

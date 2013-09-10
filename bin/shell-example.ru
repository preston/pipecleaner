require 'rack'
require 'json'
require 'httparty'

class PipeCleanerService
	def call(env)

		# PipeCleaner has fired an event trigger onto this system
		# due to a status hitting a pre-configured code (such as 'complete').
		# It's telling us to start the next stage of work, and has
		# passed along both PipeCleaner data and (optionally) any
		# existing user-defined data attached to the work item.
		# The body of the incoming request is pure JSON.
		# Decode it into a native data structure using
		# your languages native parsing library and print to debug.
		body = JSON.parse env['rack.input'].read 
		puts "---- PipeCleaner say's: ----\n#{JSON.pretty_generate(body)}\n---- That's it! ----"

		# Here's where you'd do your actual work.
		# We'll print some nonsense instead. :)
		# If this takes longer than a few hundred milliseconds, you MUST
		# do it in an asynchronous job so we can hurry up and return
		# a nice "ok" status code to PipeCleaner, whom is still waiting.
		(0..3).each do puts " ... doing stuff ... " end


		# Now the the work is done, we'll let PipeCleaner know
		# by marking this next stage complete, as well as OVERWRITTING
		# the user-defined data array. Note that if you provide the "data"
		# blob, PipeCleaner will overwrite the ENTIRE existing blob
		# for the work item. This is because PipeCleaner cannot assume
		# you're being a good netizen and setting it to something mergable,
		# such as JSON, or that the semantics are even correct.
		# In other words, if you want to merge data into this structure,
		# it is YOUR responsibility to do it here, and then overwrite the
		# existing one. Do NOT use the data blob for content larger than, say,
		# 100KB in size. If you need larger, just store an ID or URL instead.
		# As a best practice, only store JSON in the data array, and don't keep
		# jamming crap into it. This is a work items only SHARED data structure
		# across ALL pipelines in which it is flowing, so don't about the power!
		nex = body['next_stage_id']
		token = 'cu8BkyDY8JxCsiMDxpjL' # From your account page.
		resp = HTTParty.put('http://localhost:3000/statuses/ping',
			headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'},
			query: {
				auth_token: token,
				pipeline_code: 'sandbox',
				item_name: body['item_name'],
				stage_name: body['next_stage_name'],
				status_code: 'complete',
				data: {foo: Time.now}.to_json})
		puts "PipeCleaner updated with:\n#{resp}"
		[200, {"Content-Type" => "text/plain"}, ["Sweet!"]]
	end
end

Rack::Handler::Thin.run PipeCleanerService.new, Port: 9292

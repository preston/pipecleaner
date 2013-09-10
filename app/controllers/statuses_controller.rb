class StatusesController < ApplicationController

	# skip_before_filter :verify_authenticity_token, only: [:ping]

	before_filter :authenticate_user!,  except: [:landing]
	load_and_authorize_resource

	# GET /statuses
	# GET /statuses.json
	def index
		@statuses = Status.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @statuses }
		end
	end

	# GET /statuses/1
	# GET /statuses/1.json
	def show
		@status = Status.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @status }
		end
	end

	# GET /statuses/new
	# GET /statuses/new.json
	def new
		@status = Status.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @status }
		end
	end

	# GET /statuses/1/edit
	def edit
		@status = Status.find(params[:id])
	end

	# POST /statuses
	# POST /statuses.json
	def create
		@status = Status.new(params[:status])

		respond_to do |format|
			if @status.save
				format.html { redirect_to @status, notice: 'Status was successfully created.' }
				format.json { render json: @status, status: :created, location: @status }
			else
				format.html { render action: "new" }
				format.json { render json: @status.errors, status: :unprocessable_entity }
			end
		end
	end

	def advance
		member = Member.find(params[:status][:member_id])
		stage = Stage.find(params[:status][:stage_id])
		if member && stage && member.pipeline == stage.pipeline
			@status = Status.where(member_id: member, stage_id: stage).first
			if @status.nil?
				# Create one!
				@status = Status.create({user: current_user}.merge(params[:status]))
			else
				@status.update_attributes({user: current_user}.merge(params[:status]))
			end
		end
		
		respond_to do |format|
			if @status
				format.json { render json: @status }
			else
				format.json { render json: @status.errors, status: :unprocessable_entity }
			end
		end
	end

	# Requires: status_code, pipeline_code, item_name, and stage_name
	def ping
		status = nil
		msg = nil
		if params[:status_code] && params[:pipeline_code] && params[:item_name] && params[:stage_name]
			pipeline = Pipeline.where(code: params[:pipeline_code]).first
			item = Item.where(name: params[:item_name]).first
			if pipeline && item && params[:status_code]
				# puts "PIPE #{pipeline.code}"
				# puts "ITEM #{item.name}"
				member = Member.where(item_id: item.id, pipeline_id: pipeline.id).first
				stage = Stage.where(pipeline_id: pipeline.id, name: params[:stage_name]).first
				# puts "M #{member}"
				# puts "ST #{stage}"
				if member && stage && member.pipeline == stage.pipeline
					status = Status.where(member_id: member.id, stage_id: stage.id).first
					if status.nil?
						status = Status.new(member_id: member.id, stage_id: stage.id)
					end
					status.code = params[:status_code]
					data = params[:data]
					if !data.nil?
						item.data = data
					end
					status.user = current_user

					# Now deal with the JSON data blob.
					data = params[:data]
					if data
						begin
							if params[:data_mode] == 'replace'
								item.data = data
							else # merge it
								d = JSON.parse(data)
								existing = {}
								begin
									existing = JSON.parse(item.data)
								rescue #Exception => e
									puts "Corrput JSON found in database!"
								end
								item.data = existing.merge(d).to_json
							end
						rescue # Exception => e
							# puts e
							msg = "JSON blob doesn't parse look a good JSON blob should parse! Maybe you double-encoded it or something?"
						end
					end

				else
					msg = "Either stage is not part of the pipeline you specified, or the item is not a member of the pipeline."
				end
			else
					msg = "Pipeline or item not found."
			end
		else
			msg = "Requires status_code, pipeline_code, item_name, and stage_name parameters."
		end


		respond_to do |format|
			if status && status.save! && item && item.save!
				# format.html { redirect_to @status, notice: 'Status was successfully updated.' }
				format.json { render json: status }
			else
				# format.html { render action: "edit" }
				format.json { render json: msg, status: :unprocessable_entity}
			end
		end
	end

	# PUT /statuses/1
	# PUT /statuses/1.json
	def update
		@status = Status.find(params[:id])

		respond_to do |format|
			if @status.update_attributes(params[:status])
				format.html { redirect_to @status, notice: 'Status was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @status.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /statuses/1
	# DELETE /statuses/1.json
	def destroy
		@status = Status.find(params[:id])
		@status.destroy

		respond_to do |format|
			format.html { redirect_to statuses_url }
			format.json { head :no_content }
		end
	end

	protected

end

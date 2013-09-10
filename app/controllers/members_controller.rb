class MembersController < ApplicationController

	before_filter :authenticate_user!,  except: [:landing]
	load_and_authorize_resource

	before_filter :set_session_pipeline_from_params, only: [:index, :create]

	def archive
		@member = Member.find(params[:id])
		@member.archived = true
		respond_to do |format|
			if @member.save!
				format.json { render json: @member }
			else
				format.json { render json: @member.errors, status: :unprocessable_entity }
			end
		end    
	end

	def unarchive
		@member = Member.find(params[:id])
		@member.archived = false
		respond_to do |format|
			if @member.save!
				format.json { render json: @member }
			else
				format.json { render json: @member.errors, status: :unprocessable_entity }
			end
		end        
	end

	# GET /members
	# GET /members.json
	def index
		@members = @pipeline.members

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @members, include: [:item, :statuses] }
		end
	end

	# GET /members/1
	# GET /members/1.json
	def show
		@member = Member.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @member, include: :statuses }
		end
	end

	# GET /members/new
	# GET /members/new.json
	def new
		@member = Member.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @member }
		end
	end

	# GET /members/1/edit
	def edit
		@member = Member.find(params[:id])
	end

	# POST /members
	# POST /members.json
	def create
		@member = Member.new(params[:member])
		@member.pipeline = @pipeline
		respond_to do |format|
			if @member.save
				format.html { redirect_to @member, notice: 'Member was successfully created.' }
				format.json { render json: @member, status: :created }
				format.xml { render xml: @member, status: :created }
			else
				format.html { render action: "new" }
				format.json { render json: @member, status: :unprocessable_entity }
				format.xml { render xml: @member, status: :unprocessable_entity }
			end
		end
	end

	# PUT /members/1
	# PUT /members/1.json
	def update
		@member = Member.find(params[:id])

		respond_to do |format|
			if @member.update_attributes(params[:member])
				format.html { redirect_to @member, notice: 'Member was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @member.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /members/1
	# DELETE /members/1.json
	def destroy
		@member = Member.find(params[:id])
		@member.destroy

		respond_to do |format|
			format.html { redirect_to members_url }
			format.json { head :no_content }
		end
	end
end

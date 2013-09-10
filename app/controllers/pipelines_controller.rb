class PipelinesController < InheritedResources::Base

	before_filter :authenticate_user!,  except: [:landing]
	load_and_authorize_resource


	def show
		@pipeline = Pipeline.friendly_id.find(params[:id])
		respond_to do |format|
			# format.html # show.html.erb
			format.json { render json: @pipeline, include: [:stages] }
			format.xml { render xml: @pipeline, include: [:stages] }
		end
	end

	def reports
		authorize!	:show, @pipeline
	end

	def batch
	end

	def submit_batch
		puts "P: #{@pipeline}"
		data = params[:data]
		project_tags = params[:project_tags]
		success = false
		added = []
		skipped = 0
		msg = nil
		begin
			puts "PARSING: #{data}"
			CSV.parse(data) do |row|
				puts "ROW: #{row}"
				if row[0].nil? || row[0] == ''
					puts "Empty line."
				else
					puts "ADDING: '#{row[0]}', '#{row[1]}'"
					item = Item.new(name: row[0], notes: row[1])
					item.user = current_user
					item.project_list = project_tags
					item.save
					if item.id.nil?
						skipped += 1
					else
						Member.create(pipeline_id: @pipeline.id, item_id: item.id)
						added << row[0]
					end
				end
			end
	 		msg = "Added #{added.count} work items to the #{@pipeline.name} pipeline. #{skipped} were skipped."
			success = true
		rescue Exception => e
			puts "E: #{e}"
			msg = "Your data couldn't be cleanly parsed, probably due to a synax error."
		end

	
		respond_to do |format|
		 	if success
				format.html { redirect_to dashboard_path, notice: msg }
		 	else
				format.html { render action: :batch, notice: msg}
		 	end
		end
	end

	def active
		@pipeline = Pipeline.find(params[:id])
		set_session_pipeline(@pipeline)
		respond_to do |format|
			format.json { head :no_content }
			format.xml { head :no_content }
		end
	end

	def overview
		@pipeline = Pipeline.find(params[:id], include: [:stages, :items])
		respond_to do |format|
			format.html{ render partial: 'overview', locals: {pipeline: @pipeline}, layout: false }
		end
	end
	def status
		@pipeline = Pipeline.find(params[:id])
		respond_to do |format|
			format.html{ render partial: 'status', locals: {pipeline: @pipeline}, layout: false }
		end
	end
	def statistics
		@pipeline = Pipeline.find(params[:id], include: [{stages: :statuses}, :items, :members])
		respond_to do |format|
			format.html{ render partial: 'statistics', locals: {pipeline: @pipeline}, layout: false }
		end
	end
	def recent
		@pipeline = Pipeline.find(params[:id])
		respond_to do |format|
			format.html{ render partial: 'recent', locals: {pipeline: @pipeline}, layout: false }
		end
	end

	def reorder
		@pipeline = Pipeline.find(params[:id])
		order = params[:order]
		order.each_with_index do |id, index|
			s = Stage.find(id)
			puts "SID #{s.id}, INDEX #{index}"
			if s.number != index
				s.number = index
				s.save!
				puts "SAVED!"
			end
		end
		respond_to do |format|
			if @pipeline.save
				format.json { head :no_content }
				format.xml { head :no_content }
			else
				format.json { render json: @pipeline.errors, status: :unprocessable_entity }
				format.xml { render xml: @pipeline.errors, status: :unprocessable_entity }
			end
		end
	end

	# GET /pipelines
	# GET /pipelines.json
	def index
		@pipelines = Pipeline.all(include: :stages)

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @pipelines }
		end
	end


	def edit
		@pipeline = Pipeline.find(params[:id], include: [{stages: :triggers}])	
	end

	def create
		@pipeline = Pipeline.new(params[:pipeline])
		@pipeline.user = current_user
		create! { edit_pipeline_path(@pipeline) }
	end

	def update
		update! { edit_pipeline_path(@pipeline) }
	end



	def favorite
		@favorite = Favorite.new(member_id: params[:member_id], user_id: current_user.id)
		respond_to do |format|
			if @favorite.save
				# format.html { redirect_to @favorite, notice: 'Favorite was successfully created.' }
				format.json { render json: @favorite, status: :created, location: @favorite }
			else
				# format.html { render action: "new" }
				format.json { render json: @favorite.errors, status: :unprocessable_entity }
			end
		end
	end

	def unfavorite
		@favorite = Favorite.where(member_id: params[:member_id], user_id: current_user.id).first
		if @favorite
			@favorite.destroy
		end

		respond_to do |format|
			# format.html { redirect_to favorites_url }
			format.json { head :no_content }
		end
	end

end

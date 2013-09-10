class StagesController < InheritedResources::Base

	before_filter :authenticate_user!,  except: [:landing]
	before_filter :set_session_pipeline_from_params

	load_and_authorize_resource

	def new
		@stage = Stage.new
		@stage.pipeline = @pipeline
		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @stage }
		end
	end

	def create
		# @pipeline = Pipeline.friendly.find(params[:pipeline_id])
		puts "P: #{@pipeline.name}"
		@stage = Stage.new(params[:stage])
		@stage.number = @pipeline.stages.count
		@stage.pipeline = @pipeline
		create! { edit_pipeline_path(@stage.pipeline) }
	end

	def update
		puts "P: #{@pipeline.name}"
		puts "P: #{@stage.pipeline.name}"
		update! { edit_pipeline_path(@stage.pipeline) }
	end

end

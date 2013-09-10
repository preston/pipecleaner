class ApplicationController < ActionController::Base

	protect_from_forgery

	def set_session_pipeline_from_params
		code = params['pipeline_id']
		pipeline = Pipeline.friendly_id.find(code)
		if pipeline
			set_session_pipeline(pipeline)
		end
	end

	def set_session_pipeline(pipeline)
		if pipeline
			session[:pipeline_id] = pipeline.id
			@pipeline = pipeline
		end
	end

	def get_selected_pipeline_from_session
		id = session[:pipeline_id]
		if id.nil? || id == ''
			id = Pipeline.first.id
		end
		begin
			@pipeline = Pipeline.friendly_id.find(id)	
		rescue Exception => e
			# Might have been deleted.
			@pipeline = Pipeline.first
		end	
		@pipeline
	end

	def after_sign_in_path_for(resource)
		dashboard_path
	end

end

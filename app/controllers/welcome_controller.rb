class WelcomeController < ApplicationController

	before_filter :authenticate_user!,	except: [:landing, :terms, :guide, :integration]
	before_filter :get_selected_pipeline_from_session, only: [:dashboard]

	def landing
	end

	# def terms
	# end

	def dashboard
		authorize!	:show, @pipeline
		# @pipeline = Pipeline.find(@pipeline.id, include: [:stages, :members, :items])
	end

end

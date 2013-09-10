class DelayedJobsController < InheritedResources::Base

	before_filter :authenticate_user!,  except: [:landing]
	load_and_authorize_resource

	def destroy
		destroy! { queue_path }
		
	end

end
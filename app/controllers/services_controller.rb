class ServicesController < InheritedResources::Base

	before_filter :authenticate_user!
	load_and_authorize_resource

	def index
		@services = Service.paginate(:page => params[:page], :per_page => 2)

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @services }
			format.xml { render xml: @services }
		end
	end

end

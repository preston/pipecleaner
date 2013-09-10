class NotificationsController < InheritedResources::Base

	load_and_authorize_resource
	before_filter :get_selected_pipeline_from_session, only: [:user, :user_update]

	def index
		@notifications = Notification.paginate(:page => params[:page])

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @notifications }
			format.xml { render xml: @notifications }
		end
	end

	def user
		@user = current_user
		render layout: false
	end

	def user_update
		@user = current_user
		# raise :hell
		render :json => !!(current_user.update_attributes!(params[:user]))
	end

	def update
		update! { notifications_path }
	end

	def destroy
		destroy! { notifications_path }
	end

end

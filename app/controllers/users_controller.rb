class UsersController < ApplicationController

	before_filter	:authenticate_user!
  before_filter :load_user, :only => [:approve, :deny, :update, :transfer, :regenerate]

  def regenerate
    @user.reset_authentication_token
    respond_to do |format|
      format.html {
        if @user.save
          flash[:notice] = "New API key generated."
        else
          flash[:error] = "API could not be generated. Wierd. :/"
        end
        redirect_to edit_user_registration_path
      }
      # format.html { render controller: :users, action: :edit }
      # format.json { render json: @stage }
    end
  end


	def manage
    @approved = User.approved
    @pending = User.pending
    # authorize_resource(@approved + @pending)
	end

  def approve
    # authorize! :approve, @user
    approved = @user.approve!
    render :json => {:approved => approved, :html => render_to_string('_approved_user', :layout => false, :locals => {:approved_user => @user})}
  end

  def deny
    # authorize! :approve, @user
    render :json => !!(@user.deny!)
  end

  def update
    # authorize_resource(@user)
    render :json => !!(@user.update_attributes(params[:user]))
  end

  def transfer
    # authorize_resource(@user)
    if @user.transfer_ownership(User.find(params[:user][:new_owner_id]))
      flash[:notice] = 'Ownership of torrents successfully transfered'
    else
      flash[:error] = @user.errors.full_messages
    end
    redirect_to edit_user_registration_path
  end


  private
  # def authorize_resource(resource)
  #   authorize! :manage, resource
  # end

  def load_user
    @user = User.find(params[:user_id])
  end
end
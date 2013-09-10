class Ability
	include CanCan::Ability

	def initialize(user)
		# Define abilities for the passed in user here. For example:
		#
		#   user ||= User.new # guest user (not logged in)
		#   if user.admin?
		#     can :manage, :all
		#   else
		#     can :read, :all
		#   end
		#
		# The first argument to `can` is the action you are giving the user 
		# permission to do.
		# If you pass :manage it will apply to every action. Other common actions
		# here are :read, :create, :update and :destroy.
		#
		# The second argument is the resource the user can perform the action on. 
		# If you pass :all it will apply to every resource. Otherwise pass a Ruby
		# class of the resource.
		#
		# The third argument is an optional hash of conditions to further filter the
		# objects.
		# For example, here the user can only update published articles.
		#
		#   can :update, Article, :published => true
		#
		# See the wiki for details:
		# https://github.com/ryanb/cancan/wiki/Defining-Abilities
	
		user ||= User.new # guest user (not logged in)
		cannot :manage, :all
		cannot :approve, User
		cannot :deny, User
		cannot :transfer, User

		if user.id.nil?

		else #all users
			can :manage, User, :id => user.id
			cannot :approve, User, :id => user.id
			cannot :deny, User, :id => user.id

			can :manage, User, :user_id => user.id
			can :show, Pipeline
			can :active, Pipeline
			can :overview, Pipeline
			can :recent, Pipeline
			can :statistics, Pipeline
			can :status, Pipeline
			can :favorite, Pipeline
			can :unfavorite, Pipeline

	
			# You may only manage your own notifications.
			can [:create, :destroy, :update, :show], Notification, user: {id: user.id}

			if user.is_guest? || user.is_normal? || user.is_admin?
				can :read, Service
			end

			if user.is_normal? || user.is_admin?
				can :advance, Status
				can :ping, Status
			end

			if user.is_admin?
				can :approve, User
				can :deny, User
				can :manage, :all # User can peform any action on any object.
				# can :create, Feed
				# can :create, Torrent
			end

		end
	end

end


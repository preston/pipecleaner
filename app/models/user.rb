class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :lockable, :timeoutable
	devise	:database_authenticatable, :registerable,
					:recoverable, :rememberable, :trackable, :validatable,
					:token_authenticatable, :confirmable

	# devise :omniauthable, :omniauth_providers => [:openid]

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :approved, :notifications_attributes

	GUEST_ROLE = 'guest'
	ADMIN_ROLE = 'admin'
	USER_ROLE = 'user'

	has_many  :items,				foreign_key: :created_by
	has_many  :pipelines,		foreign_key: :created_by
	has_many  :statuses,		foreign_key: :created_by
	has_many  :favorites,		dependent: :destroy
	has_many  :notifications,	dependent: :destroy, :before_add => :set_nest


	scope :pending, where(:approved => false)
	scope :approved, where(:approved => true)

	after_create :reset_authentication_token
	after_create :send_admin_mail
	after_update :send_confirmation


	accepts_nested_attributes_for	:notifications, allow_destroy: true

	def has_history?
		self.items.count > 0 || self.pipelines.count > 0 || self.statuses.count > 0
	end

	def active_for_authentication? 
		super && approved? 
	end 

	def inactive_message 
		if !approved? 
			:not_approved 
		else 
			super
		end 
	end

	def send_confirmation
		if self.approved_changed?
			::Devise.mailer.confirmation_instructions(self).deliver
		end
	end

	def transfer_ownership(user)
		if !user or user.id.nil?
			errors.add(:base, "User must be specified to transfer ownership.")
			return false
		else
			self.statuses.update_all(:created_by => user.id)
			self.pipelines.update_all(:created_by => user.id)
			self.items.update_all(:created_by => user.id)
		end
	end

	def approve!
	  self.approved = true
	  self.save
	end

	def send_admin_mail
		AdminMailer.new_user_waiting_for_approval(self).deliver 
	end

	def deny!
		AdminMailer.deny_application(self).deliver
		self.destroy
	end

	def is_guest?
		self.role == User::GUEST_ROLE
	end

	def is_normal?
		self.role == User::USER_ROLE
	end

	def is_admin?
		self.role == User::ADMIN_ROLE
	end

	private

	# http://stackoverflow.com/questions/2611459/ruby-on-rails-nested-attributes-how-do-i-access-the-parent-model-from-child-m
	def set_nest(o)
		o.user ||= self
	end

end

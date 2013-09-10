PipeCleaner::Application.routes.draw do


	resources :notifications do
		collection do
			get 'user', as: :user_notifications
			put 'user_update', as: :user_notifications_update
		end

	end


	resources :services do
		member do
			get 'test'
		end
	end
	
	resources :favorites
	resources :delayed_jobs

	match "/documents/:file_or_folder", :controller => :documents, :action => :get_file, :file_or_folder => /.*/
	resources :documents, :only => :get_file

	devise_for :users
	resources :users

	get 'manage' => 'users#manage'

	resources :pipelines do
		member do
			get 'reports'
		end
		resources :stages do
		  resources :triggers
		end
		member do
			put	'reorder'
			get 'overview'
			get 'status'
			get 'statistics'
			get 'recent'
			put 'active'
			get 'batch'
			post 'batch' => 'pipelines#submit_batch', as: :submit_batch
			post 'favorite'
			delete 'unfavorite'
		end
		resources :members do
			member do
				put 'archive'
				put 'unarchive'
			end
		end
	end


	resources :statuses do
		collection do
			post 'advance'
			put	'ping'
		end
	end
	resources :items do
		member do
			put 'associate'
			put 'disassociate'
			get 'data'
		end
		collection do
			get 'find'
		end
	end
	resources :pipelines


	get 'welcome' => "welcome#landing",  as: 'landing'
	get 'dashboard' => "welcome#dashboard", as: 'dashboard'
	get 'api' => "welcome#api",  as: 'api'
	get 'integration' => "welcome#integration",  as: 'integration'
	get 'guide' => 'welcome#guide',	as: 'guide'
	get 'terms' => 'welcome#terms',	as: 'terms'
	get 'queue' => 'welcome#queue', as: 'queue'
	get 'mashup' => 'welcome#mashup', as: 'mashup'

	# User management.
	get 'manage' => 'users#manage'
	post 'manage/:user_id/deny' => 'users#deny', as: :deny_user
	post 'manage/:user_id/approve' => 'users#approve', as: :approve_user
	put  'manage/:user_id' => 'users#update', as: :update_user
	post 'manage/:user_id/transfer' => 'users#transfer', as: :transfer_ownership
	post 'manage/:user_id/regenerate_api_token' => 'users#regenerate', as: :regenerate

	root :to => "welcome#landing"

	# rails_admin
	mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'


end

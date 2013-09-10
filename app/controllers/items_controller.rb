class ItemsController < ApplicationController

	before_filter :authenticate_user!
	load_and_authorize_resource

	def associate
		member = Member.where(item_id: params[:id], pipeline_id: params[:pipeline_id]).first
		if member
			# Already exists!
		else
			member = Member.new(item_id: params[:id], pipeline_id: params[:pipeline_id])
		end
		member.save!
		respond_to do |format|
			format.json { head :no_content }
			format.xml { head :no_content }
		end
	end

	def disassociate
		member = Member.where(item_id: params[:id], pipeline_id: params[:pipeline_id]).first
		if member
			member.destroy
		end
		respond_to do |format|
			format.json { head :no_content }
			format.xml { head :no_content }
		end
	end

	# GET /items
	# GET /items.json
	def index
		@items = Item.paginate(:page => params[:page], :per_page => 10)

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @items }
			format.xml { render xml: @items }
		end
	end
	
	def data
		@item = Item.find(params[:id])
		render layout: false
	end

	def find
		if(params[:like].nil?)
			items = Item.where(name: params[:name])
		else
			items = Item.where("name like ?", "%#{params[:name]}%")
		end
		respond_to do |format|
			# format.html # show.html.erb
			format.json { render json: items, include: {:members => {include: [:pipeline, :statuses]}} }
			format.xml { render xml: items, include: {:members => {include: [:pipeline, :statuses]}} }
		end
	end


	# GET /items/1
	# GET /items/1.json
	def show
		@item = Item.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @item }
			format.xml { render xml: @item }
		end
	end

	# GET /items/new
	# GET /items/new.json
	def new
		@item = Item.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @item }
		end
	end

	# GET /items/1/edit
	def edit
		@item = Item.find(params[:id])
	end

	# POST /items
	# POST /items.json
	def create
		@item = Item.new(params[:item])
		@item.user = current_user
		respond_to do |format|
			if @item.save
				format.html { redirect_to items_path, notice: 'Item was successfully created.' }
				format.json { render json: @item, status: :created, location: @item }
				format.xml { render xml: @item, status: :created, location: @item }
			else
				format.html { render action: "new" }
				format.json { render json: @item, status: :unprocessable_entity }
				format.xml { render xml: @item, status: :unprocessable_entity }
			end
		end
	end

	# PUT /items/1
	# PUT /items/1.json
	def update
		@item = Item.find(params[:id])

		respond_to do |format|
			if @item.update_attributes(params[:item])
				format.html { redirect_to items_path, notice: 'Item was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @item.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /items/1
	# DELETE /items/1.json
	def destroy
		@item = Item.find(params[:id])
		@item.destroy

		respond_to do |format|
			format.html { redirect_to items_url }
			format.json { head :no_content }
		end
	end
end

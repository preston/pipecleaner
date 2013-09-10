class DocumentsController < ApplicationController

	before_filter :authenticate_user!

	def get_file
		path = File.join(Rails.root, 'doc', params[:file_or_folder])
		puts path
		if path.length > 0
		    puts path
		    if File.directory?(path)
				path += "/index.html"
			end
		    send_file path
		else
		    render :text => "File Not Found"
		end
	end

end

class Admin::ResourceController < AdminController
	def destroy
		RepoResource.find_by_id(params[:id]).destroy
  	render json:{status: true}
	end

	def reset
		_item = RepoResource.find_by_id(params[:id])
		_item.update_attributes({:recsts=> _item.recsts == '0' ? "1" : '0'})
		render json:{status: true}
	end
end

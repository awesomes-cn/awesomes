class ResourceController < ApplicationController
	before_action :mem_login

	def save
		_id = params[:id]
		_item = RepoResource.find_by_id(_id)
		_para = {:title=> params[:title],:url=> params[:url],:repo_id=> params[:repo_id]}
		if _item 
			render json: {status: false} and return if _item.mem != current_mem or _item.recsts == '0'
			_item.update_attributes(_para)
		else
			_item = RepoResource.create(_para)
			_item.mem_id = current_mem.id
			_item.save
		end
		render json: {status: true}

	end

	def destroy
		_item = RepoResource.find_by_id(params[:id])
		render json: {status: false} and return if _item.mem != current_mem or _item.recsts == '0'
		_item.destroy
		render json: {status: true}
	end
end

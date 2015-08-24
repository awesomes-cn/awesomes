class Admin::MemController < AdminController
	def destroy
		Mem.find_by_id(params[:id]).destroy
    render json:{status: true}
	end
end

class Admin::ReadmeController < AdminController
	def destroy
    Readme.find_by_id(params[:id]).destroy
    render json:{status: true}
  end
end

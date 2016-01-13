class Admin::AdController < AdminController
  def destroy
    Ad.find_by_id(params[:id]).destroy
    render json:{status: true}
  end
end

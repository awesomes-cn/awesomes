class Admin::WeuseapplyController < AdminController
  def destroy
    Msg.find_by_id(params[:id]).destroy
    render json:{status: true}
  end
end

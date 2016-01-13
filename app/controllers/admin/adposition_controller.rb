class Admin::AdpositionController < AdminController
  def destroy
    Adposition.find_by_id(params[:id]).destroy
    render json:{status: true}
  end
end

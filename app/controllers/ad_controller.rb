class AdController < ApplicationController
  def psave
    @item = Adposition.find_by_id(params[:adposition][:id]) || Adposition.new
    @item.update_attributes(params.require(:adposition).permit(Adposition.attribute_names))
    render json:{status: true, item: @item}
  end

  def new
    @suburl = "/ad/save"
    @item = Ad.new
  end

  def edit
    @suburl = "/ad/save"
    @item = Ad.find_by_id params[:id]
    render "new"
  end

  def save
    @item = Ad.find_by_id(params[:ad][:id]) || Ad.new
    @item.update_attributes(params.require(:ad).permit(Ad.attribute_names))
    redirect_to "/admin/ads"
  end
end

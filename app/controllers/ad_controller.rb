class AdController < ApplicationController
  def psave
    @item = Adposition.find_by_id(params[:adposition][:id]) || Adposition.new
    @item.update_attributes(params.require(:adposition).permit(Adposition.attribute_names))
    render json:{status: true, item: @item}
  end
end

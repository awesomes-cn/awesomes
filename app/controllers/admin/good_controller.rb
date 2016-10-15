class Admin::GoodController < ApplicationController
  def save
    _item = Good.find_by_id(params[:good][:id]) || Good.new
    _item.update_attributes(params.require(:good).permit(Good.attribute_names))
    render json: {:item=> _item,:status=> true}  
  end

  def destroy
    Good.find_by_id(params[:id]).destroy
    render json:{status: true}
  end
end

class Admin::LinkController < AdminController
  def save
    _item = Link.find_by_id(params[:link][:id]) || Link.new
    _item.update_attributes(params.require(:link).permit(Link.attribute_names))
    render json: {:item=> _item,:status=> true}  
  end

  def destroy
    
  end
end

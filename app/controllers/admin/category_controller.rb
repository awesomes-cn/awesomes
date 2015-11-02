class Admin::CategoryController < AdminController
  def destroy
    _item = Menutyp.find_by_id(params[:id])
    
    if Menutyp.where({:parent=> _item.key}).count > 0
      render json: {status: false} and return
    end

    _item.destroy
    render json: {status: true}
  end

  def save
    _para = {
      :key=> params[:key],
      :sdesc=> params[:sdesc],
      :parent=> params[:parent],
      :typcd=> params[:typcd],
      :icon=> params[:icon]
    }

    _item = Menutyp.find_by_id(params[:id]) || Menutyp.new

    _item.update_attributes _para
    render json: _item
  end
end

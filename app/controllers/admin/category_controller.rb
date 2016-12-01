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
      :icon=> params[:icon],
      :alia=> params[:alia],
      :group=> params[:group]
    }

    _item = Menutyp.find_by_id(params[:id])
    if _item
      _repos = Repo.where({:rootyp=> _item.parent,:typcd=> _item.key})
      if _item.parent != params[:parent]
        _repos.update_all({:rootyp=> params[:parent]})
      end
      if _item.key != params[:key]
        _repos.update_all({:typcd=> params[:key]})
      end
    else
      _item = Menutyp.new
    end

    _item.update_attributes _para
    render json: _item
  end
end

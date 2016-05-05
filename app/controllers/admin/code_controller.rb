class Admin::CodeController < AdminController
  before_action :lost

  
  def lost
    @item = Code.find_by_id(params[:id])
  end

  def destroy
    @item.destroy
    render json:{status: true}
  end

  def switch
    @item.status = (@item.status == 'ACTIVED' ? 'NORMAL' : 'ACTIVED')
    @item.save
    render json:{result: @item.status}
  end
end

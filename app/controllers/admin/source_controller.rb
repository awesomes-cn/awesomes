class Admin::SourceController < AdminController
  before_filter :source_lost
  
  def source_lost
    @item = Topic.find_by_id(params[:id])
  end

  def destroy
    @item.destroy
    render json:{status: true}
  end

  def review
    @item.update_attributes({:state=> '0'})
    render json: @item.state
  end
end

class CategoryController < ApplicationController
  before_action :category_lost

  def category_lost 
     @item = Menutyp.where({:key=> params[:typ],:typcd=> 'B'}).first
  end
  
  def home
    render :layout=> 'no_right_bar'
  end
  def uphome 
    @item.update_attributes({:home=> params[:home]})
    redirect_to request.referer
  end
end

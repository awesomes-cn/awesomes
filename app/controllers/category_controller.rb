class CategoryController < ApplicationController
  before_filter :category_lost
  def home
    render :layout=> 'no_right_bar'
  end
  def uphome 
    @item.update_attributes({:home=> params[:home]})
    redirect_to request.referer
  end
end

class CodeController < ApplicationController
  before_filter :code_lost 

  def code_lost
    @item = Code.find_by_id(params[:id])
  end

  def index
    @repo = @item.repo
  end

  def fork
    _item = @item.dup
    _item.mem_id = current_mem.id
    _item.save
    redirect_to "/code/#{_item.id}"
  end

  def info
    @item.update_attributes({:title=> params[:title]})
    render json: {status: true}
  end

  def save
    @item.update_attributes({
      :js=> params[:js],
      :css=> params[:css],
      :html=> params[:html]
    })
    render json: {status: true}
  end
end

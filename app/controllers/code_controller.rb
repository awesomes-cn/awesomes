class CodeController < ApplicationController
  def index
    @item = Code.find_by_id(params[:id])
    @repo = @item.repo
  end

  def fork
    @item = Code.find_by_id(params[:id])

    _item = @item.dup
    _item.mem_id = current_mem.id
    _item.save
    redirect_to "/code/#{_item.id}"
  end
end

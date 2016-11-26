class CssController < ApplicationController
  before_action :code_lost, :except=> ['libs', 'libversions', 'libfiles']

  def code_lost
    @is_new = false
    @item = Code.find_by_id(params[:id])
    if !@item || @item.typcd != 'css'
      @item = Code.new({:typcd=> 'css'})
      @item.mem = current_mem
      @item.title = "新建代码"
      @is_author = !current_mem.nil?
      @is_new = true
    else
      @is_author = (current_mem and @item.mem_id == current_mem.id)
    end
    
  end

  def save
    render json: {status: false} and return if @item.mem_id != current_mem.id
    @item.update_attributes({
      :js=> params[:js],
      :css=> params[:css],
      :html=> params[:html],
      :title=> params[:title]
    })

    render json: {status: true, id: @item.id}
  end

end

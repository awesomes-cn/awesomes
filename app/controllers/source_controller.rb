class SourceController < ApplicationController
  before_filter :source_lost,:except=> ['new']
  before_filter :mem_login,:only=> ['new']

  def source_lost 
    @item = Topic.find_by_id(params[:id])
  end

  def index
    @comment = {:typ=> 'SOURCE',:idcd=> @item.id}
  end

  def new
    @item = Topic.new
  end

  

end

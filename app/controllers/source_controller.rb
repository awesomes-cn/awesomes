class SourceController < ApplicationController
  before_filter :source_lost,:except=> ['new']
  before_filter :mem_login,:only=> ['new','save']

  def source_lost 
    @item = Topic.find_by_id(params[:id])
  end

  def index
    @comment = {:typ=> 'TOPIC',:idcd=> @item.id}
  end

  def new
    @item = Topic.new
  end

  def save
    _para = params[:topic]
    Topic.create({:title=> _para[:title],:typcd=> 'SOURCE',:con=> _para[:con],:mem_id=> current_mem.id,:tag=> _para['tag']})
    redirect_to "/tip/source"
  end
end

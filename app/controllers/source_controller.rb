class SourceController < ApplicationController
  before_filter :source_lost,:except=> ['new']
  before_filter :mem_login,:only=> ['new','save']
  before_filter :admin_or_author_filter,:only=> ['update']

  def source_lost 
    @item = Topic.find_by_id(params[:id])
  end

  def admin_or_author
    session[:mem] == 1 or current_mem.id == Topic.find_by_id(params[:id]).mem_id
  end

  def admin_or_author_filter
    redirect_to '/' and return if admin_or_author
  end

  def index
    if @item.state == '1'
      redirect_to '/tip',:notice=> t("topic_review") and return if !admin_or_author
    end
   
    @comment = {:typ=> 'TOPIC',:idcd=> @item.id}
    _topics = Topic.where({:typcd=> 'SOURCE',:state=> '0'})
    @next = _topics.order('id desc').where("id < #{@item.id}").offset(0).limit(1).first || _topics.last
  end

  def new
    @suburl = "/source/save"
    @item = Topic.new
  end

  def edit
    @suburl = "/source/update"
    render 'new'
  end

  def save
    _para = params[:topic]
    Topic.create({:title=> _para[:title],:typcd=> 'SOURCE',:origin=> params[:origin],:con=> _para[:con],:mem_id=> current_mem.id,:tag=> _para['tag']})
    redirect_to "/tip/source"
  end

  def update
    _para = params[:topic]
    @item.update_attributes({:title=> _para[:title],:con=> _para[:con],:origin=> _para[:origin],:tag=> _para['tag']})
    redirect_to "/source/#{@item.id}"
  end

  def visit
    @item.visit += 1
    @item.save
    render text: true
  end
end

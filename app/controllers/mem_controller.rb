require "github"
class MemController < ApplicationController
  before_action :is_me?,:except=>['login','auth','ckemail','cknc']
  
  def index
    #if @mem.mem_rank.blank? and !@mem.mem_info.github.blank?

      #@mem.mem_rank = MemRank.create
      #@mem.save
      #Github.sync_mem_rank @mem
    #end
    @opers = Oper.order('`order` asc').where({:opertyp=> 'USING',:typ=> 'REPO',:mem_id=> @mem.id}).includes('use_repo')
    #@repos = Repo.where({id: _rids})

  end

  def info
    
  end 
  

  def login
    session[:login_callback] = request.referer
    redirect_to "/auth/#{params[:from]}"
  end

  def topics
    @items = data_list @mem.topics
    @count = @mem.topics.count
  end

  def marks
    _query = Oper.where({:opertyp=> 'MARK',:typ=> 'REPO',:mem_id=> @mem.id})
    @items = data_list _query
    @count = _query.count
  end

  def docs
    @items = data_list_asc @mem.readmes
    @count = @mem.readmes.count
  end

  def codes
    @items = data_list_asc @mem.codes
    @count = @mem.codes.count
  end

  def comments
    @items = data_list @mem.comments
    @count = @mem.comments.count
  end

  def sync_repo
    Github.mem_sync_repo current_mem
    redirect_to request.referer
  end

  def ckemail
    render json: !(Mem.find_by_email params[:email]).nil?
  end

  def cknc
    _nc = (params[:nc] || params[:mem][:nc]).strip
    render json: true and return if current_mem and current_mem.nc == _nc
    render json: (Mem.find_by_nc _nc).nil?
  end
  
  def update
    @mem.update(params.require(:mem).permit('nc','role'))
    redirect_to request.referer,:notice=> @mem.errors.messages.values.flatten.join("，") and return if @mem.invalid? 
    @mem.mem_info.update(params.require(:mem_info).permit(MemInfo.attribute_names))
    redirect_to request.referer
  end

  def nc
    _mem = Mem.find_by_nc params[:search]
    redirect_to "/mem/#{_mem.id}"
  end

  def uptx
    @mem.update({avatar: params[:avatar]})
    render json: true
  end

  def msgs
    @items = data_list Msg.where({:to=> current_mem.id})
    @count = Msg.where({:to=> current_mem.id}).count
    @unreadids = @items.select{|item|
      item.status == 'UNREAD'
    }.map{|item| item.id}.join(",")
  end


end

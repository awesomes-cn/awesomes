require "github"
class MemController < ApplicationController
  before_filter :is_me?,:except=>['login','auth','ckemail','cknc']
  
  def index
    if @mem.mem_rank.blank? and !@mem.mem_info.github.blank?

      @mem.mem_rank = MemRank.create
      @mem.save
      Github.sync_mem_rank @mem
    end
  end

  def auth
    _data = request.env["omniauth.auth"] 
    #render json: _data and return

    _provider = params[:provider]
    _para = {
      :provider => _provider,
      :uid => _data['uid']
    }
    _mauth = Mauth.where(_para).first

    #头像
    _avatar_url = ''
    _raw_info = _data['extra']['raw_info']
    if _provider == 'github'
      _avatar_url = _raw_info['avatar_url'] 
    end
    if _provider == 'weibo'
      _avatar_url = _data['extra']['raw_info']['avatar_hd']
    end
    
    #注册 /  绑定账号
    if _mauth.nil?
      _mem = current_mem
      if !_mem
        _mem = Mem.create({
          :nc => _data['info']['nickname'], 
          :avatar => _avatar_url,
          :email => _raw_info[:email]
        })
        _mem.mem_info.update_attributes({
          :gender => _data['extra']['gender'],
          :location=> _raw_info['location'],
          :html_url=> _raw_info['html_url'],
          :blog=> _raw_info['blog'],
          :followers=> _raw_info['followers'],
          :following=> _raw_info['following'],
          :github=> _raw_info['login']
        })

        if _provider == 'github'
          Github.mem_sync_repo _mem
        end
      end 
      _mem.mauths.create(_para)
    else 
      _mem = _mauth.mem
      if _mem.avatar == 'default.png'
        _mem.update_attributes({:avatar=> _avatar_url})
      end
    end
    session[:mem] = _mem.id
    redirect_to session[:login_callback]
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
    _query = Oper.where({:opertyp=> 'MARK',:typ=> 'REPO',:mem_id=> current_mem.id})
    @items = data_list _query
    @count = _query.count
  end

  def docs
    @items = data_list_asc @mem.readmes
    @count = @mem.readmes.count
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
    @mem.update(params.require(:mem).permit('nc'))
    redirect_to request.referer,:notice=> @mem.errors.messages.values.flatten.join("，") and return if @mem.invalid? 
    @mem.mem_info.update(params.require(:mem_info).permit(MemInfo.attribute_names))
    redirect_to request.referer
  end

  def nc
    _mem = Mem.find_by_nc params[:search]
    redirect_to "/mem/#{_mem.id}"
  end

end

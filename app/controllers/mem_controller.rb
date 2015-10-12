require "github"
class MemController < ApplicationController
  before_filter :is_me?,:except=>['login','auth']
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
    if _provider == 'github'
      _avatar_url = _raw_info['avatar_url']
    end
    
    #注册 /  绑定账号
    if _mauth.nil?
      _mem = current_mem
      if _mauth
        create _data, _provider, _avatar_url
      end
      _mem.mauths.create(_para)
      session[:mem] = _mem.id
    else 
      _mem = _mauth.mem
      if _mem.avatar.blank?
         _mem.update_attributes({:avatar=> _avatar_url})
      end
      session[:mem] = _mem.id
    end
    #render json: _data and return
    redirect_to session[:login_callback]
  end

  def create data,provider,avatar_url
    _raw_info = data['extra']['raw_info']
    

    _mem = Mem.create({
      :nc => data['info']['nickname'], 
      :avatar => avatar_url,
      :email => _raw_info[:email]
    })


    _mem.mem_info.update_attributes({
      :gender => data['extra']['gender'],
      :location=> _raw_info['location'],
      :html_url=> _raw_info['html_url'],
      :blog=> _raw_info['blog'],
      :followers=> _raw_info['followers'],
      :following=> _raw_info['following'],
      :github=> _raw_info['login']
    })
    Github.mem_sync_repo _mem
  rescue
  end

  def login
    session[:login_callback] = request.referer
    redirect_to "/auth/#{params[:from]}"
  end

  def index
    @items = data_list_asc @mem.readmes
    @count = @mem.readmes.count
  end

  def comments
    @items = data_list_asc @mem.comments
    @count = @mem.comments.count
  end

  def sync_repo
    Github.mem_sync_repo current_mem
    redirect_to request.referer
  end
  
end

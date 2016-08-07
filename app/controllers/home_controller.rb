class HomeController < ApplicationController
  include HomeControllerCommon
  include HomeOtherAction

  before_action :admin_login, :only => [:trend]
  before_action :assign_base_info, :only => [:repos, :search]
  before_action :set_repos_list, :only => [:trend, :repos]

  def index
    @links = Link.order order: :desc
    @root_menus = Menutyp.root_menus
    @repos_count = Repo.count
    @news = Repo.order('id desc').limit(12)
    @trends = Repo.order('trend desc').limit(5)
    @usemems = Mem.where('`using` > 0').order('reputation desc').limit(4)
  end

  def subscribe
    @news = Repo.order('id desc').limit(15)
    render :layout=> nil
  end

  def sleep
    render :layout=> nil
  end
  def sleeprule
    render :layout=> nil
  end

  def search
    @items = Repo.search(params[:q], {"hitsPerPage" => 15, "page" => page})
    @count = @items.raw_answer['nbHits'] || 0
    @root = Menutyp.find_by_key params[:root]
    @typ = Menutyp.find_by_key params[:typ]
  end

  def trend;end

  def repos
    @typ = Menutyp.sub_menus.find_by key: params[:root] if params[:root].present?
  end

  def weuse
    _query = Mem.where('(role = ? or reputation >= 20) and `using` >= 5', 'vip').order("reputation desc").includes(:mem_info)
    @count = _query.count
    @mems = data_list(_query, 5)
  end

  def joinuse 
    respond_to do |format|
      format.html {
      }

      format.json {
        _repos = data_list(Repo.select('id, name, cover, owner, alia').where.not({rootyp: "NodeJS"}).order("(stargazers_count + forks_count + subscribers_count) desc"), 120)
        render json: {
          items: _repos,
          usings: current_mem ? current_mem.usedrepos.pluck('id') : []
        }.to_json(:methods => ['link_url'])
      }
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
          :nc=> get_auth_nc(_data['info']['nickname']),
          :avatar => _avatar_url,
          #:email => _raw_info[:email]
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
      else
        _mem.mem_info.update_attributes({
          :github=> _raw_info['login']  
        })
      end  
      _mem.mauths.create(_para)
    else 
      _mem = _mauth.mem
      if _mem.avatar == 'default.png'
        _mem.update_attributes({:avatar=> _avatar_url})
      end
    end
    _mem.update_attributes({:reputation=> _raw_info['followers']})
    session[:mem] = _mem.id
    render :layout=>nil
  end

  def auth_callback
    render :layout=> nil
  end

  private
  def set_repos_list
    @sort = params[:sort].blank? ? :hot : params[:sort]
    query = {}
    query.merge! rootyp: params[:root] if params[:root].present?
    query.merge! typcd: params[:typ] if params[:typ].present?
    _tag_search = "tag like ?", "%#{_tag}%" if params[:tag].present?
    _map = {:hot => "(stargazers_count + forks_count + subscribers_count)", :new => "github_created_at", :trend => "trend"}
    _sort = "#{_map[@sort.to_sym]} desc"
    @items = data_list(Repo.where(query).where(_tag_search).order(_sort)).includes(:repo_trends)
    @count = Repo.where(query).where(_tag_search).count
    @root = Menutyp.find_by_key params[:root]
    @typ = Menutyp.find_by_key params[:typ]
  end

  def assign_base_info
    @root_menus = Menutyp.root_menus
    @sub_menus = Menutyp.sub_menus
    @page_title = "#{assign_page_title} - awesomes"
  end

  def get_auth_nc nc
    _mem = Mem.find_by_nc nc
    _mem ? nc + "-#{Time.new.to_i}" : nc
  end

end

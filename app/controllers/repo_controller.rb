class RepoController < ApplicationController
  before_action :repo_lost
  before_action :admin_login,:only=> ["edit","update","readme_en",'syncreadme','avoid','accept']
  before_action :mem_login,:only=>['readme']
  
  def repo_lost
    @item = @repo = Repo.find_by({:owner=> params[:owner],:alia=> params[:alia]})
  end

  def index
    @lang = I18n.locale
    @lang = 'en' if @item.about_zh.blank?
    @lang = params[:lang] || @lang
    @trends = @item.repo_trends.order('id desc').pluck('trend')[0..10].reverse.join(',')
    @relates = Repo.where({:rootyp=> @repo.rootyp, :typcd=> @repo.typcd}).where.not({:id=> @repo.id}).order('trend desc').limit(4)
  end 

  def translation
    render :layout=> nil
  end

  def commits
    @readmes = @item.readmes
  end

  def diff
    @readme = Readme.find_by_id(params[:oid])
  end

  def readme
    @canbelock = @item.can_be_lock? current_mem

    if @canbelock[:status]
      @item.lock current_mem
    end
  	
  end

  def readme_en 
    respond_to do |format|
      format.html{ 
        render :layout=> "blank"
      }
      format.json { 
        @item.update_attributes({:about=> params[:markdown]})
        redirect_to request.referer 
      }
    end
  end

  def experiences
    @comment = {:typ=> 'REPOEXPERIENCE',:idcd=> @item.id}
  end

  def update
    if params[:typ] 
      _typ = params[:typ].split("-")
      params[:repo][:rootyp] = _typ[0]
      params[:repo][:typcd] = _typ[1..-1].join('-')
    end
    @item.update_attributes(params.require(:repo).permit(Repo.attribute_names))
    @item.up_typ_zh
    redirect_to request.referer 
  end

  def resources
    _items = @item.repo_resources
    if current_mem
      _items = _items.where("recsts = '0' or mem_id = ?",current_mem.id)
    else
      _items = _items.where({:recsts=> '0'})
    end
    render json:{items:  _items}
  end

  def notify
    @item.update_attributes({:outdated=> '1'})
  end

  def syncreadme
    _readme_url = "https://api.github.com/repos/#{@item.full_name}/readme?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
    _response = RestClient.get _readme_url, {:accept => "application/vnd.github.VERSION.raw"}
    @readme = _response.body
  end

  def avoid
    @item.update_attributes({:outdated=> '0'})
    redirect_to @item.link_url
  end

  def accept
    _readme_url = "https://api.github.com/repos/#{@item.full_name}/readme?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
    _response = RestClient.get _readme_url, {:accept => "application/vnd.github.VERSION.raw"}
    _readme = _response.body
    @item.update_attributes({:about=> _readme,:outdated=> '0'})
    redirect_to @item.link_url
  end

  def new
    @submit = Submit.new
  end

  def using
    _mids = Oper.where({:opertyp=> 'USING',:typ=> 'REPO',:idcd=> @item.id}).limit(50).pluck('mem_id')
    @mems = Mem.where({id: _mids})
  end

  def favors
    _mids = Oper.where({:opertyp=> 'MARK',:typ=> 'REPO',:idcd=> @item.id}).limit(50).pluck('mem_id')
    @mems = Mem.where({id: _mids})
  end


  def unlock
    if current_mem.id != @item.lock_mem.id and session[:mem] != 1
      render json: false and return 
    end
    @item.unlock
    redirect_to request.referer
  end
end

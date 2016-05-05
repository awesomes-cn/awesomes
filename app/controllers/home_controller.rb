class HomeController < ApplicationController
  include HomeControllerCommon

  before_action :admin_login, :only => [:trend]
  before_action :set_page_title, :only => [:repos, :search]
  before_action :assign_base_info, :only => [:repos, :search]
  before_action :set_repos_list, :only => [:trend, :repos]

  def index
    @links = Link.order order: :desc
    @root_menus = Menutyp.root_menus
    @repos_count = Repo.count
  end

  def search
    search_results = Repo.search(
        params[:q],
        limit: page_size,
        offset: page * page_size,
        fields: %w(full_name typcd_zh typcd rootyp_zh rootyp description description_cn tag)
    )
    @items = search_results
    @count = search_results.total_count
    @root = Menutyp.find_by_key params[:root]
    @typ = Menutyp.find_by_key params[:typ]
  end

  def trend

  end

  def repos
    @typ = Menutyp.sub_menus.find_by key: params[:root] if params[:root].present?
  end

  def docs
    render :layout => nil
  end


  def markdown
    @item = Site.find_by({:typ => 'MARKDOWN'}) || Site.create({:typ => 'MARKDOWN'})
    respond_to do |format|
      format.html {
      }
      format.json {
        @item.update_attributes({:fdesc => params[:markdown]})
        redirect_to request.referer
      }
    end
  end

  def sitemap
    respond_to do |format|
      format.html {
        render text: 'please visit .xml page' and return
      }
      format.xml {
        render :layout => nil
      }
      format.txt {
        render :layout => nil
      }
    end

  end

  def test
    #render json: Repo.search("apples", limit: 10, offset: 0).total_count
  end

  def login
    respond_to do |format|
      format.html {
        session[:login_callback] = request.referer
      }
      format.json {
        _pwd = Digest::MD5.hexdigest params[:pwd]
        _mem = Mem.find_by({:email => params[:email]})

        #登陆
        if _mem
          #redirect_to request.referer,:notice=> t('tip.pwd_error') and return if _mem.pwd != _pwd
          render json: {status: false, notice: t('tip.pwd_error')} and return if _mem.pwd != _pwd
        else
          _mem = Mem.create({:email => params[:email], :pwd => _pwd, :nc => params[:nc].strip})
          #redirect_to request.referer,:notice=> _mem.errors.messages.values.flatten.join("，") and return if _mem.invalid?          
          render json: {status: false, notice: _mem.errors.messages.values.flatten.join("，")} and return if _mem.invalid?
        end

        session[:mem] = _mem.id
        #redirect_to session[:login_callback] || '/mem'
        render json: {
            status: true,
            login: {
                status: true
            }

        }
      }
    end
  end

  def logout
    session['mem'] = nil
    redirect_to request.referer
  end

  def find_pwd
    respond_to do |format|
      format.html {

      }
      format.json {
        _email = params[:email]
        _str = encode("#{_email}-#{Time.new.to_i}")
        _url = "#{ENV["BASE_URL"]}pwd_reset?key=#{_str}"
        MemMailer.find_pwd({:to => _email, :url => _url}).deliver
        redirect_to request.referer, :notice => 'OK'
      }
    end
  end

  def pwd_reset
    respond_to do |format|
      format.html {
        redirect_to '/tip', :notice => '链接失效，请重新获取' and return if params[:key].blank?
        _key = decode(params[:key]).split('-')
        redirect_to '/tip', :notice => '链接失效，请重新获取' and return if Time.new.to_i - _key[1].to_i > 3600
      }
      format.json {
        _key = decode(params[:key]).split('-')
        redirect_to request.referer, :notice => '邮箱错误或链接无失效' and return if _key[0] != params[:email] or Time.new.to_i - _key[1].to_i > 3600
        _mem = Mem.find_by_email(_key[0])
        _pwd = Digest::MD5.hexdigest params[:pwd]
        redirect_to request.referer, :notice => '当前邮箱尚未注册' and return if !_mem
        _mem.update_attributes({:pwd => _pwd})
        redirect_to '/tip', :notice => '密码重置成功，马上登陆吧' and return
      }
    end
  end

  def rss
    _items = Readme.order(id: :desc).limit(15).offset(0).includes(:repo)
    @items = _items.map do |item|
      _root = Menutyp.menu_a item.repo.rootyp
      _typ = Menutyp.menu_b item.repo.typcd, item.repo.rootyp
      {
          :title => "[#{_root.sdesc}-#{_typ.sdesc}] #{item.repo.name}",
          :author => item.repo.owner,
          :link => "#{Rails.application.config.base_url}repo/#{item.repo.owner}/#{item.repo.alia}",
          :date => item.created_at,
          :desc => item.repo.description,
          :category => "#{item.repo.rootyp}-#{item.repo.typcd}"
      }
    end.uniq[0...10]
    respond_to do |format|
      format.html
      format.xml { render :layout => nil }
    end
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
  end

  def set_page_title
    @page_title = "#{assign_page_title} - awesomes"
  end

end

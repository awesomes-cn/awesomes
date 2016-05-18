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
    @news = Repo.order('id desc').limit('6')
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

  def trend;end

  def repos
    @typ = Menutyp.sub_menus.find_by key: params[:root] if params[:root].present?
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

end

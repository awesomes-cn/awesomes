class RepoController < ApplicationController
  before_filter :repo_lost 
  before_filter :admin_login,:only=> ["edit","update","readme_en",'syncreadme','avoid','accept']
  def index
    @lang = params[:lang] || (@item.about_zh.blank? ? 'en' : 'zh')
    @comment = {:typ=> 'REPO',:idcd=> @item.id}
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
  	render :layout=> "blank"
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

  def update
    _typ = params[:typ].split("-")
    params[:repo][:rootyp] = _typ[0]
    params[:repo][:typcd] = _typ[1..-1].join('-')
    #params[:repo][:about_zh] = "" if params[:repo][:about_zh].gsub(/<\w>\s+?<\/\w>/,"") == ""
    @item.update_attributes(params.require(:repo).permit(Repo.attribute_names))
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
end

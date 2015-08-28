class Admin::RepoController < AdminController
  def destroy
    Repo.find_by_id(params[:id]).destroy
    render json:{status: true}
  end

  def sync
    Thread.new{sync_post}.join 
  end

  def sync_post
    _repo = Repo.find_by_id(params[:id]) 
    _url = _repo.html_url

    _api_url = "https://api.github.com/repos#{_url.split(/http(s)?:\/\/github.com/).last}?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
    
    require 'rest-client'
    _response = RestClient.get _api_url
    _result = JSON.parse(_response.body)
    _homepage = _result['homepage']
    if _homepage and _homepage.index("http://") != 0 and _homepage.index("https://") != 0
      _homepage = "http://#{_homepage}"
    end
    _para = {
      :homepage=> _homepage,
      :stargazers_count=> _result['stargazers_count'],
      :forks_count=> _result['forks_count'],
      :subscribers_count=> _result['subscribers_count'],
      :owner => _result['owner']['login']
    }
    _repo.update_attributes(_para)

    #_readme_url = "https://api.github.com/repos/#{_result['full_name']}/readme?client_id=#{Rails.application.config.github_client_id}&client_secret=#{Rails.application.config.github_client_secret}"
    #_response = RestClient.get _readme_url, {:accept => "application/vnd.github.VERSION.raw"}
    #_readme = _response.body
    #_repo.about = _readme
    #_repo.save
    render json: true and return
  end
end

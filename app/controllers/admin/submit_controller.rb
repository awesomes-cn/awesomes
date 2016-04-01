class Admin::SubmitController < AdminController
  def fetch
    Thread.new{fetch_post}.join
  end

  def fetch_post
    _submit = Submit.find_by_id(params[:id])
    _url = _submit.html_url  
    
    if !Repo.find_by_html_url(_url.gsub(/http[s]?/,"https"))

      _api_url = "https://api.github.com/repos#{_url.split(/http(s)?:\/\/github.com/).last}?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
      
      require 'rest-client'
      _response = RestClient.get _api_url
      _result = JSON.parse(_response.body)
      _homepage = _result['homepage']
      if _homepage and _homepage.index("http://") != 0 and _homepage.index("https://") != 0
        _homepage = "http://#{_homepage}"
      end

      render json: {status: false} and return if Repo.find_by_html_url( _result['html_url'])

      _para = {
        :name=> _result['name'],
        :full_name=> _result['full_name'],
        :alia=> _result['name'].downcase.gsub(/\W/,'-'),
        :html_url=> _result['html_url'],
        :description=> _result['description'],
        :homepage=> _homepage,
        :stargazers_count=> _result['stargazers_count'],
        :forks_count=> _result['forks_count'],
        :subscribers_count=> _result['subscribers_count'],
        :pushed_at=> _result['pushed_at'],
        :typcd=> _submit.typcd,
        :rootyp=> _submit.rootyp,
        :owner=> _result['owner']['login'],
        :github_created_at=> _result['created_at'],

      }
      _repo = Repo.create(_para)

      _readme_url = "https://api.github.com/repos/#{_result['full_name']}/readme?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
      _response = RestClient.get _readme_url, {:accept => "application/vnd.github.VERSION.raw"}
      _readme = _response.body
      _repo.about = _readme.force_encoding('utf-8')
      _repo.save
      _repo.up_typ_zh
      _repo.update_typ_num 
    end
      
    _submit.status = "READED"
    _submit.save
    
    render json: {status: true} and return
  end

  def destroy
    Submit.find_by_id(params[:id]).destroy
    render json: {status: true}
  end
end

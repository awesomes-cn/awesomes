class Github
  def  self.mem_sync_repo mem
    require 'rest-client' 
    _response = RestClient.get "https://api.github.com/users/#{mem.mem_info.github}/repos?page=1&per_page=5"
    _result = JSON.parse(_response.body) 
    MemRepo.where({:mem_id=> mem.id}).delete_all
    _result.each do |item|
      mem.mem_repos << MemRepo.create({
        :name=> item['name'],
        :html_url=> item['html_url'],
        :description=> item['description'],
        :stargazers_count=> item['stargazers_count']
      })
    end
  rescue
  end

  def self.sync_repo_attr repo
    _url = repo.html_url
    _api_url = "https://api.github.com/repos#{_url.split(/http(s)?:\/\/github.com/).last}?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
    
    require 'rest-client'
    _response = RestClient.get _api_url
    _result = JSON.parse(_response.body)
    _para = {
      :stargazers_count=> _result['stargazers_count'],
      :forks_count=> _result['forks_count'],
      :subscribers_count=> _result['subscribers_count'],
      :pushed_at=> _result['pushed_at'],
      :github_created_at=> _result['created_at'],
      :description=> _result['description']
    }
    repo.update_attributes(_para)
    repo
  rescue  
  end 

  def self.get_repo_cover repo
    _url = repo.html_url
    _api_url = "https://api.github.com/repos#{_url.split(/http(s)?:\/\/github.com/).last}?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
    
    require 'rest-client'
    _response = RestClient.get _api_url
    _result = JSON.parse(_response.body)
    _result['owner']['avatar_url']
  rescue  
  end 

  def self.sync_mem_rank  mem
    _api_url = "http://github-awards.com//api/v0/users/#{mem.mem_info.github}.json?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
    
    require 'rest-client'
    _response = RestClient.get _api_url
    _result = JSON.parse(_response.body)
    _rank = _result["user"]["rankings"]
    return if _rank.blank?    
    _data = _rank.select{|m| m["language"] == "javascript"}.first
    return if _data.blank?
    mem.mem_rank.update_attributes({
      :worldwide=> _data["world_rank"],
      :country=> _data["country_rank"]
    })
  rescue  
  end

  def self.get_repo_issue  repo
    _api_url = "https://api.github.com/repos/#{repo.full_name}/issues?state=all&page=1&per_page=20&client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
    
    require 'rest-client'
    _response = RestClient.get _api_url
    _result = JSON.parse(_response.body)

    _times = _result.map do |item|
      if item['state'] == 'open'
        (Time.now - item['created_at'].to_time) / (item['comments'] == 0 ? 1 : item['comments'])
      else
        item['closed_at'].to_time - item['created_at'].to_time
      end
    end
    repo.update_attributes({
      :issue_res=> _times[0] ? (_times.reduce(:+) / _times.count).to_i : 0
    })
  rescue
  end

end

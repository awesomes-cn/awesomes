class Github
  def mem_sync_repo mem
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
  end
end
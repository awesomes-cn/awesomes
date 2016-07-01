class RankController < ApplicationController
  def index
    _map = {:hot => "(stargazers_count + forks_count + subscribers_count)", :trend => "trend"}
    @sort = params[:sort] || 'hot'
    @items = data_list(Repo.where.not({rootyp: "NodeJS"}).order("#{_map[@sort.to_sym] } desc"), 100)
  end
end

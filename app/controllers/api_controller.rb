class ApiController < ActionController::Base
  def readme
    _item = Repo.find_by({:owner=> params[:owner],:name=> params[:name]})
    render json: {
      code: 1  # 1 不存在该库
    } and return  if !_item


    _readme = _item.about_zh
    _has_zh = !_readme.blank?
    if !_has_zh
      _readme = _item.about
    end
    
    if params[:format] == 'html'
      _readme = GitHub::Markdown.render _readme
    end

    render json: {
      code: 0,
      owner: params[:owner],
      name: params[:name],
      has_zh: _has_zh,#是否存在中文说明
      readme: _readme
    }

  end

  def latest
    render json: {
      :items=> repo_query.order('id desc').limit(15)
    }.to_json(:methods => ['cover_path', 'issue_friendly'])
  end

  def search
    render json: {
      :items=> repo_query.search(params[:q], {"hitsPerPage" => 40, "page" => 0})
    }.to_json(:methods => ['cover_path','issue_friendly'])
  end

  def top
    _map = {:hot => "(stargazers_count + forks_count + subscribers_count)", :trend => "trend"}
    _sort = params[:sort] || 'hot'
    render json: {
      :items=> repo_query.where.not({rootyp: "NodeJS"}).order("#{_map[_sort.to_sym] } desc").limit(50)
    }.to_json(:methods => ['cover_path', 'issue_friendly'])
  end

  def subjects
    render json: {
      :items=> Subject.order('`order` desc')
    }
  end

  def subject
    render json: {
      :items=> Subject.order('`order` desc')
    }
  end

  private
  def repo_query
    Repo.select('id,name,description,cover,description_cn,pushed_at,typcd_zh,stargazers_count,trend,`using`,issue_res')
  end
end

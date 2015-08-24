class ApiController < ApplicationController
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
end

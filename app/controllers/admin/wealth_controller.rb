class Admin::WealthController < ApplicationController
  def save
    _price = params[:price]
    if params[:model] == 'code'
      _code = Code.find params[:id]
      WealthLog.add _price, _code.mem_id, _code, "发布代码 [#{_code.title}](/code/#{_code.id})"
      render json: true
    end
    if params[:model] == 'comment'
      _comment = Comment.find params[:id]
      WealthLog.add _price, _comment.mem_id, _comment, "发布评论在 [#{_comment.target_name}](#{_comment.target_url})"
      render json: true
    end

    if params[:model] == 'readme'
      _readme = Readme.find params[:id]
      WealthLog.add _price, _readme.mem_id, _readme, "发布中文说明 [#{_readme.repo.name}](/repo/daneden/animate-css/diff/#{_readme.id})"
      render json: true
    end
  end
end

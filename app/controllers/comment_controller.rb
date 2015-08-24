class CommentController < ApplicationController
	before_filter :mem_login
  before_filter :comment_lost,:except=> ['save']
	def save
		if (_id = params[:id]) and (_item = Comment.find_by_id(_id))
      comment_lost
      _item.update_attributes({:con=> params[:con]})
    else
      _item = Comment.create({:typ=> params[:typ],:idcd=> params[:idcd],:con=> params[:con],:mem_id=> current_mem.id})
    end
    render json: {status: true,url: _item.target_url} 
	end

  def destroy 
    @item.destroy
    render json: {status: true}
  end

  def edit
    @comment = {:typ=> @item.typ,:idcd=> @item.idcd,:id=> @item.id}
  end

end

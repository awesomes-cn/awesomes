class CommentController < ApplicationController
	before_action :mem_login, :except=> ['list']
  before_action :comment_lost,:except=> ['save', 'list']

  def comment_lost
    @item = Comment.find(params[:id])
    render json: {status: false} and return if @item.mem != current_mem
  end
  
	def save
		if (_id = params[:id]) and (_item = Comment.find_by_id(_id))
      comment_lost
      _item.update_attributes({:con=> params[:con]}) 
    else
      _item = Comment.create({:typ=> params[:typ],:idcd=> params[:idcd],:con=> params[:con],:mem_id=> current_mem.id})
      _item.target.update_comment
      Msg.add_comment(current_mem, Mem.find(1), _item.target_name, _item.target_url)
      params[:con].gsub(/@([^:：?\s@]+)/) do | nc | 
        p "==#{nc.delete '@'}==="
        _mem = Mem.find_by_nc nc.delete '@'
        if _mem and _mem.id != current_mem.id
          Msg.add_comment_at(current_mem, _mem, _item.target_name, _item.target_url)
        end
      end
    end
    render json: {status: true, item: _item}.to_json(:include => {:mem => {:only=>[:nc,:id], :methods=> ['avatar_url']}}, :methods=> ['raw_con', 'friendly_time'])  and return
	end

  def destroy
    @item.destroy
    @item.target.update_comment
    render json: {status: true}
  end

  def edit
    @comment = {:typ=> @item.typ,:idcd=> @item.idcd,:id=> @item.id}
  end

  def list 
    items = Comment.where({:typ=> params[:typ], :idcd=> params[:idcd]})
    
    if current_mem
      favors = Oper.where({:opertyp=> 'FAVOR', :typ=> 'COMMENT', mem_id: current_mem.id}).pluck('idcd')
    end

    render json: {
      items: items,
      favors: favors || []
    }.to_json(:include => {:mem => {:only=>[:nc,:id], :methods=> ['avatar_url']}}, :methods=> ['raw_con', 'friendly_time'])
  end

end

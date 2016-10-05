class OperController < ApplicationController
  before_action :mem_login

  def para
    {:opertyp=> params[:opertyp],:typ=> params[:typ],:idcd=> params[:idcd],:mem_id=> current_mem.id}
  end

  def whether
    render json: Oper.where(para).count > 0
  end

  def update
    _para = para

    if params[:typ] == 'COMMENT' and params[:opertyp] == 'FAVOR'
      if current_mem.id == Comment.find_by_id(params[:idcd]).mem_id
        render json: {status: false} and return
      end
    end


    if (_tmp = _oper = Oper.find_by(_para))
      _oper.destroy
    else
      if params[:opertyp] == 'USING'
        max_order = Oper.where({:opertyp=> params[:opertyp], :typ=> params[:typ], :mem_id=> current_mem.id}).maximum('order')  || 0
        
        _para[:order] = max_order + 10000
      end
      _tmp = Oper.create(_para)

      if _tmp.typ == 'COMMENT' and _tmp.opertyp == 'FAVOR'
        _comment = _tmp.target
        Msg.add_comment_favor(current_mem, _comment.mem, _comment.target_name, _comment.target_url)
      end

    end

    current_mem.update_oper params[:opertyp], params[:typ] 

    render json: {
      status: true,
      state: Oper.where(_para).count > 0,
      count: _tmp.update_target,
      max_order: _para
    }
  end

  def uporder
    _oper = Oper.find_by_id(params[:id])
    _oper.order = params[:order]
    _oper.save
    render json: true
  end
end

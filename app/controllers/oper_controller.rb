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
    if (_tmp = _oper = Oper.find_by(_para))
      _oper.destroy
    else
      if params[:opertyp] == 'USING'
        max_order = Oper.where({:opertyp=> params[:opertyp], :typ=> params[:typ], :mem_id=> current_mem.id}).maximum('order')
        
        _para[:order] = max_order + 10000
      end
      _tmp = Oper.create(_para)
    end
    render json: {
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

class Oper < ActiveRecord::Base
  def target
    typ.capitalize.constantize.send :find,idcd
  end

  def update_target
    _count = Oper.where({:opertyp=> opertyp,:typ=> typ,:idcd=> idcd}).count
    _item = target
    _item[opertyp.downcase.to_sym] = _count
    _item.save
    _count
  end
end

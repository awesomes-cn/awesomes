class WealthLog < ApplicationRecord
  def self.add amount, mem_id, target, remark
    amount = amount.to_f
    _mem = Mem.find_by_id mem_id
    if !_mem || amount == 0.0
      return
    end
    _balance = _mem.wealth + amount
    create({
      :amount=> amount,
      :mem_id=> mem_id,
      :remark=> remark,
      :balance=> _balance
    })

    _mem.update_attributes({:wealth=> _balance})

    target.update_attributes({:wealth=> amount})
  end
end

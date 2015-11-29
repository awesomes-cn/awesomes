class Notify < ActiveRecord::Base
  belongs_to :mem


  def self.socket mem_id
    Notify.where({:mem_id=> mem_id,:state=> 'UNREAD'}).group('typcd').count
  end
end

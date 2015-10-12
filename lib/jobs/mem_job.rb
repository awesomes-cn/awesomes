class MemJob < ApiController
  def self.aync_avatar
    Mem.where("avatar like 'http%'").each do |mem|
      _name = "#{Time.now.strftime("%y%m%d%H%M%S")}-#{rand(99).to_s}.jpg"
      ApplicationController.new.upload_remote(mem.avatar,_name,'mem')
      mem.update_attributes({:avatar=> _name})
      p "=====#{mem.id}====="
    end  
    p "=====success aync avatar====="
  end
end

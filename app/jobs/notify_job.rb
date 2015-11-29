class NotifyJob < ActiveJob::Base
  queue_as :default

  def perform item
    Notify.create(item)
    require 'rest-client'
    RestClient.post "http://192.168.141.128:8080/notify",{
      :mem=> encode("#{item[:mem_id]}-#{Time.now.to_i}")
    }.merge(Notify.socket(item[:mem_id]))
  end


  def encode(des_text)
    des = OpenSSL::Cipher::Cipher.new(ENV['ENCODE_ALG'])
    des.encrypt
    des.key = ENV['ENCODE_KEY']
    des.iv = ENV['ENCODE_IV']
    result = des.update(des_text)
    result << des.final
    return Base64.encode64 result
  end
end

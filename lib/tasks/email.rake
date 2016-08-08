namespace :subscribe do 
  task :send, [:start] => :environment do |t,args| 
    require 'rest_client'
    response = RestClient.post "http://www.sendcloud.net/webapi/mail.send_template.json",
      :api_user => "HXH568701382", # 使用api_user和api_key进行验证
      :api_key => "MQbO5u5jmTkElNbw",
      :from => "1246996371@qq.com", # 发信人，用正确邮件地址替代
      :fromname => "Awesomes.cn",
      :use_maillist => 'true',
      :to => "awesomes-test@maillist.sendcloud.org", # 使用地址列表的别称地址
      :template_invoke_name => 'Awesomes',
      :subject => " Awesomes.cn-开源前端框架",
      :resp_email_id => 'true'

    puts response.code
    puts response.to_str
  end
end
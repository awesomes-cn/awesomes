class Topic < ActiveRecord::Base
  belongs_to :mem


  def update_comment
    update_attributes({:comment=> Comment.where({:typ=> 'TOPIC',:idcd=> id}).count})
  end

  def reponm
    origin.to_s.gsub(/http(.+)\/(.+)?#(.+)/,'\2')
  end

  def self.push_seo
    require 'net/http'
    urls = Topic.all.map{|m| "#{ENV["BASE_URL"]}/source/#{m.id}"}
    uri = URI.parse("http://data.zz.baidu.com/urls?site=www.awesomes.cn&token=#{ENV['BAIDU_PUSH_TOKEN']}&type=original")
    req = Net::HTTP::Post.new(uri.request_uri)
    req.body = urls.join("\n")
    req.content_type = 'text/plain'
    res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
    puts res.body
  end
end

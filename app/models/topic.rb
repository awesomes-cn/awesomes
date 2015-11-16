class Topic < ActiveRecord::Base
  belongs_to :mem


  def update_comment
    update_attributes({:comment=> Comment.where({:typ=> 'TOPIC'}).count})
  end

  def reponm
    origin.to_s.gsub(/http(.+)\/(.+)?#(.+)/,'\2')
  end
end

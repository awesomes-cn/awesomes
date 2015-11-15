class Topic < ActiveRecord::Base
  belongs_to :mem


  def update_comment
    update_attributes({:comment=> Comment.where({:typ=> 'TOPIC'}).count})
  end
end

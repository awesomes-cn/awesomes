class Code < ActiveRecord::Base
  belongs_to :mem
  belongs_to :repo


  def update_comment
    _count = Comment.where({:typ=> 'CODE', :idcd=> id}).count
    update_attributes({
      :comment=> _count
    })
  end
end

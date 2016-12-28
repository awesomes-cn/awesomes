class Log < ApplicationRecord
  def self.task_begin key, title
    create(:typcd=> 'Task', :key=> key, :title=> title, :state=> 'on', :begtime=> Time.new)
  end

  def task_end
    update_attributes({:state=> 'success', :endtime=> Time.new})
  end
end

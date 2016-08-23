module SubjectHelper

  def subject_list 
    @items = data_list(Subject.order('`order` desc,id desc'))
    @count = Subject.count
  end
end

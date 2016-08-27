module SubjectHelper

  def subject_list 
    @items = data_list(Subject.order('`order` desc,id desc'))
    @count = Subject.count
  end

  def subtitle
    @item.title.empty? ? @repo.name.capitalize : @item.title
  end

  def subdesc
    @item.sdesc.empty? ? @repo.description_cn : @item.sdesc
  end
end

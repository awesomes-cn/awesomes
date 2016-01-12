module SubjectHelper
  def subject_repo_list
    _query = Repo.where("tag like ?","%#{@item.title}%").order("(stargazers_count + forks_count + subscribers_count) desc")
    @items = data_list(_query)
    @count = _query.count
  end

  def subject_list 
    @items = data_list(Subject.order('`order` desc,id desc'))
    @count = Subject.count
  end
end

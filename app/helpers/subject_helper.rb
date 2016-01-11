module SubjectHelper
  def subject_repo_list
    _query = Repo.where("tag like ?","%#{params[:key]}%")
    @items = data_list(_query)
    @count = _query.count
  end

  def subject_list
    @items = Subject.order('`order` desc,id desc').limit(page_size).offset(page * page_size)
    @count = Subject.count
  end
end

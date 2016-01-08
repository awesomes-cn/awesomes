module SubjectHelper
  def subject_repo_list
    _query = Repo.where("tag like ?","%#{params[:key]}%")
    @items = data_list(_query)
    @count = _query.count
  end

  def subject_list
    @items = data_list(Subject)
    @count = Subject.count
  end
end

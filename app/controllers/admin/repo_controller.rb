class Admin::RepoController < AdminController
  def destroy
    Repo.find_by_id(params[:id]).destroy
    render json:{status: true}
  end

  def sync
    Thread.new{sync_post}.join 
  end

  def sync_post
    Github.sync_repo_attr(Repo.find_by_id params[:id])
    render json: true and return
  end
end

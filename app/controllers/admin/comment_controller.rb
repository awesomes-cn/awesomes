class Admin::CommentController < AdminController
  def destroy
    Comment.find_by_id(params[:id]).destroy
    render json:{status: true}
  end
end

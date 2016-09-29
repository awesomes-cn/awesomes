module CommentHelper
  def comment typ, idcd
    @comment = {:typ=> typ, :idcd=> idcd}
    render "layouts/comment"
  end
end

class SubjectController < ApplicationController
  before_filter :admin_login,:only=> ["new","update"]
  before_filter :subject_lost,:except=> ["new","update"]

  def subject_lost
    @item = Subject.find_by_key params[:key]
  end
  def new
    @item = Subject.new
  end

  def edit
    render "new"
  end

  def update
    @item = Subject.find_by_id(params[:subject][:id]) || Subject.new
    @item.update_attributes(params.require(:subject).permit(Subject.attribute_names))
    redirect_to "/admin/subjects"
  end
end

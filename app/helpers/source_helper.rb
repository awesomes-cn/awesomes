module SourceHelper
  def is_author
    current_mem and current_mem.id == Topic.find_by_id(params[:id]).mem_id
  end
end

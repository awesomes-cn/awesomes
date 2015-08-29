require "github"
class Admin::MemController < AdminController
	def destroy
		Mem.find_by_id(params[:id]).destroy
    render json:{status: true}
	end

  def sync
    Github.new.mem_sync_repo Mem.find_by_id(params[:id])
    render json:{status: true}
  end
end

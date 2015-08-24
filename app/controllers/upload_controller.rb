class UploadController < ApplicationController
  def get_filename(file)
    "#{Time.now.strftime("%y%m%d%H%M%S")}-#{rand(99).to_s}-#{session[:mem].to_s}.#{file.original_filename.split('.').last}"
  end

  def pic
    _file = params[:filedata]
    _folder = params[:folder]
    _width = params[:width].to_i
    _height =  params[:height].to_i
    _file_name = get_filename(_file)
    _path = upload_pic(_file,_file_name,_folder,_width,_height)
    _path = aliyun_upload File.open("#{Rails.root}/public/upload/#{_folder}/#{_file_name}"),"#{_folder}/#{_file_name}"
    render text: {status: true,file_path: "#{Rails.application.config.source_access_path}#{_folder}/#{_file_name}",src: _file_name}.to_json
  end 
end

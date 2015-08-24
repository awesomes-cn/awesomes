desc 'Fill the test data into DB' #带参数指定表 rake dbdata[MemAccount]
task :dbdata,[:table] => :environment do |t,args|
  require 'find'
  _folder =Rails.root.to_s + '/db/data/'  
  _files = Find.find(_folder).select{|f|File.file?(f)}
  if !args[:table].nil?
    _files =[Rails.root.to_s + "/db/data/#{args[:table]}.yml"]
  end
  _files.each do |file|
    _fileds = file.split('/')
    _file_name = _fileds.last
    _model = _file_name.split('.')[0]
    _datas = YAML.load(File.read(file))
    _is_repeat = eval("#{_model}.where(#{_datas['data'][0]}).count > 0")
    if !_is_repeat
      _datas['data'].each{|item|
        eval("#{_model}.create(#{item})") 
      } 
      puts "----#{_file_name}----is OK---" 
    else
      puts "----#{_file_name}----is repeat!!---"
    end
  
  end  
end



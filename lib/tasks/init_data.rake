desc 'Fill the test data into DB' #带参数指定表 rake dbdata[MemAccount]
task :dbdata, [:table] => :environment do |t, args|
  require 'find'
  _folder =Rails.root.to_s + '/db/data/'
  _files = Find.find(_folder).select { |f| File.file?(f) }
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
      _datas['data'].each { |item|
        eval("#{_model}.create(#{item})")
      }
      puts "----#{_file_name}----is OK---"
    else
      puts "----#{_file_name}----is repeat!!---"
    end

  end
end

namespace :db do
  namespace :repos do
    desc 'mock some  test data for local dev etc: rake "db:repos:mock[true]"'
    task :mock, [:reset] => :environment do |_, args|
      # Repo.delete_all if args[:reset].present? #just for clear repos data
      sub_menus = Menutyp.sub_menus.select(:key, :parent, :fdesc)
      sub_menus.all.each_with_index do |menu, index|
        (1..10).to_a.each do |i|
          name = "jquery_#{index}_#{i}"
          demo = {
              name: name,
              full_name: "#{name}/#{name}",
              alia: "#{name}_alia",
              html_url: 'https://github.com/jquery/jquery',
              description: 'jQuery JavaScript Library',
              homepage: 'https://jquery.com/',
              stargazers_count: (index+1) * i,
              forks_count: (index+19) * i,
              subscribers_count: (index+30) * i,
              pushed_at: Time.current,
              typcd: menu.key,
              rootyp: menu.parent,
              owner: "awsome-cn_#{index}",
          }
          #should comment Repo model searchkick methods when exception
          repo = Repo.create demo
          puts "--> current mock: #{repo.name}"
        end
      end
    end
  end
end



module CodeHelper
  def is_code_author
    is_login and current_mem.id == @item.mem.id
  end

  def packages
    require 'find'
    _folder = Rails.root.to_s + '/public/sandbox/'  
    _categories = sub_directories _folder

    _categories.map do |item|
      _subs = sub_directories "#{Rails.root.to_s}/public/sandbox/#{item}"
      
       _files = _subs.map do |sub|
         #{sub.to_sym=> sub_files("#{Rails.root.to_s}/public/sandbox/#{item}/#{sub}")}
         {
          :name=> sub,
          :file=> sub_files("#{Rails.root.to_s}/public/sandbox/#{item}/#{sub}")
         }
       end

      #{item.to_sym=> _files}
      {
        :name=> item,
        :file=> _files
      }
    end
  end


  def librarys
    require 'find'
    _folder = Rails.root.to_s + '/public/sandbox/'  
    sub_directories _folder
  end

end

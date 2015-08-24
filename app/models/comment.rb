class Comment < ActiveRecord::Base
	belongs_to :mem

  after_create do |item|
    ActionController::Base.new.expire_fragment "comments_#{item.typ}_#{item.idcd}"
  end

  after_destroy do |item|
    ActionController::Base.new.expire_fragment "comments_#{item.typ}_#{item.idcd}"
  end

	def friendly_time 
    created_at.friendly_i18n  
  end

  def raw_con
    #CGI::escapeHTML(GitHub::Markdown.render con).gsub(/&lt;([!script])(.+?)&gt;/){ |m|
    #  "<$1 #{CGI::unescapeHTML($2)}>"
    #}.gsub(/&lt;\/([!script])&gt;/,'</$1>')
    TrustHtml.sanitize(GitHub::Markdown.render con).gsub(/@([^:：?\s@]+)/,"<a href='/mem/nc/\\1' target='_blank'>@\\1</a>")
  end

  def target
    typ.capitalize.constantize.send :find,idcd
  end

  def target_url
    if typ == "REPO"
      "/repo/#{target.owner}/#{target.alia}"
    end
  end
end

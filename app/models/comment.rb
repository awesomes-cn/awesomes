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
    TrustHtml.sanitize(GitHub::Markdown.render con).gsub(/@([^:：?\s@]+)/,"<a href='/mem/nc/\\1' target='_blank'>@\\1</a>")
    #(GitHub::Markdown.render con).gsub(/@([^:：?\s@]+)/,"<a href='/mem/nc/\\1' target='_blank'>@\\1</a>")
  end

  def target
    typ.capitalize.constantize.send :find,idcd
  end

  def target_url
    if typ == "REPO"
      "#{target.link_url}"
    end
    if typ == "TOPIC"
      "/source/#{idcd}"
    end
  end
end

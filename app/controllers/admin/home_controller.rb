class Admin::HomeController < AdminController
  def submits
    adminlists Submit,[:html_url,:typcd,:status]
  end

  def readmes
    adminlists Readme,[:repo_id,:mem_id,:status,:sdesc,:wealth],:include => {:repo => {:only=>[:name,:id],:methods=>['alia','link_url']},:mem => {:only=>[:nc,:id]}}
  end

  def repos
    adminlists Repo,[:name,:html_url,:typcd,:rootyp,:alia,:owner,:outdated],:methods => ['link_url']
  end

  def docsubs
    adminlists Docsub,[:name,:mem_id,:status],:include => {:mem => {:only=>[:nc,:id]}}
  end

  def docs
    adminlists Doc,[:name,:mem_id],:include => {:mem => {:only=>[:nc,:id]}}
  end

  def resources
    adminlists RepoResource,[:title,:url,:repo_alia,:recsts],:include => {:mem => {:only=>[:nc,:id]}}
  end

  def mems
    adminlists Mem,[:nc,:email,:wealth]
  end

  def comments
    adminlists Comment,[:typ,:idcd,:mem_id,:con,:wealth],:include => {:mem => {:only=>[:nc,:id]}},:methods=> ['target_url']
  end

  def categorys
    adminlists Menutyp.order("id asc"),[:key,:sdesc,:icon,:typcd,:parent,:icon, :alia, :group]
  end

  def sources
    adminlists Topic,[:title,:visit,:favor,:comment,:state,:mem_id],:include => {:mem => {:only=>[:nc,:id]}}
  end

  def subjects
    adminlists Subject,[:title,:key,:amount,:order]
  end

  def ads
    adminlists Ad,[:name,:visit,:position]
  end
  def adpositions
    adminlists Adposition,[:name,:key]
  end

  def links
    adminlists Link,[:name,:url,:order]
  end

  def codes
    adminlists Code,[:title,:status,:mem_id,:repo_id,:wealth], :include => {:mem => {:only=>[:nc,:id]}, :repo => {:only=>[:owner,:alia, :id, :name], :methods=> ['link_url']}}
  end

  def weuseapplys
    adminlists Msg.where({:typ=> 'weuseapply'}),[:con,:from]
  end
  
  def subscribes
    adminlists Subscribe,[:email]
  end

  def goods
    adminlists Good,[:name,:cover,:price,:order,:desc]
  end
end

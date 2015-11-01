class Admin::HomeController < AdminController
  def submits
    adminlists Submit,[:html_url,:typcd,:status]
  end

  def readmes
    adminlists Readme,[:repo_id,:mem_id,:status,:sdesc],:include => {:repo => {:only=>[:name,:id],:methods=>['alia','link_url']},:mem => {:only=>[:nc,:id]}}
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
    adminlists Mem,[:nc,:email]
  end

  def comments
    adminlists Comment,[:typ,:idcd,:mem_id,:con],:include => {:mem => {:only=>[:nc,:id]}},:methods=> ['target_url']
  end

  def categorys
    adminlists Menutyp,[:key,:sdesc,:icon,:typcd]
  end
end

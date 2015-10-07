module RepoHelper
  def hometyp
    Menutyp.order("home_index desc").limit(10).offset(0)
  end

  def recommends
    Repo.order('recommend desc').limit(6).offset(0)
  end
end

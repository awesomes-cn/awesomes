module AdHelper
  def ad_tag position
    Ad.where({:position=> position}).all.sample(1).first
  end
end

class MemInfo < ActiveRecord::Base
  belongs_to :mem

  def location
    super.blank? ? "潘多拉星球" : super
  end
end

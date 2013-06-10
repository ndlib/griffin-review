class ReserveListing

  delegate :id, :file, :url, :title, :course, :creator_contributor, :details, :publisher_provider, to: :reserve

  attr_accessor :reserve

  def initialize(reserve)
    @reserve = reserve
  end


  def css_class
    "record-book"
  end


  def link_to_get_listing?
    GetReserve.new(@reserve).link_to_listing?
  end



end

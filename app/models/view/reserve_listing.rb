class ReserveListing

  delegate :id, :file, :url, :title, :course, :creator_contributor, :details, :publisher_provider, to: :reserve

  attr_accessor :reserve

  def initialize(reserve)
    @reserve = reserve
  end


  def css_class
    case @reserve.type
    when "BookReserve"
      "record-book"
    when "BookChapterReserve"
      "record-book"
    when "JournalReserve"
      "record-journal"
    when "VideoReserve"
      "record-video"
    when "AudioReserve"
      "record-audio"
    else
      "record-book"
    end
  end


  def link_to_get_listing?
    ReserveResourcePolicy.new(@reserve).can_be_linked_to?
  end


  def is_editable?
    ReserveIsEditablePolicy.new(@reserve).is_editable?
  end


end

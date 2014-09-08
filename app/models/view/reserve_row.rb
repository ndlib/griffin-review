class ReserveRow
  include RailsHelpers

  delegate :id, :file, :url, :title, :length, :course, :creator_contributor, :details, :publisher_provider, :realtime_availability_id, to: :reserve

  attr_accessor :reserve

  def initialize(reserve, current_user)
    @reserve = reserve
    @current_user = current_user
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


  def title
    if link_to_get_listing?
      if @reserve.selection_title.present?
        helpers.raw "#{helpers.link_to @reserve.selection_title, routes.course_reserve_path(@reserve.course.id, @reserve.id), target: '_blank'}<br><span class=\"subtitle\">#{@reserve.title}</span>"
      else
        helpers.link_to @reserve.title, routes.course_reserve_path(@reserve.course.id, @reserve.id), target: '_blank'
      end
    else
      if @reserve.selection_title.present?
        helpers.raw "#{@reserve.selection_title}<br><span class=\"subtitle\">#{@reserve.title}</span>"
      else
        @reserve.title
      end
    end
  end


  def link_to_get_listing?
    ReserveCanBeViewedPolicy.new(@reserve, @current_user).can_be_viewed?
  end


  def is_editable?
    ReserveIsEditablePolicy.new(@reserve).is_editable?
  end


  def show_check_availability?
    @reserve.realtime_availability_id && @reserve.physical_reserve? && @reserve.currently_in_aleph?
  end


  def show_pages?
    reserve.type == 'BookChapterReserve' && reserve.length.present?
  end

end

class AdminReserve

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper

  attr_accessor :reserve

  delegate :workflow_state, :title, :length, to: :reserve

  def initialize(current_user, context, params)
    @current_user = current_user
    @context = context
    @reserve = reserve_search.get(params[:id])

    ReserveCheckInprogress.new(@reserve).check!
  end


  def button
    @button ||= AdminEditButton.new(@reserve)
  end


  def type
    reserve.type.gsub('Reserve', '')
  end


  def info_list
    uls = []

    uls << "Fair Use: #{fair_use}"
    if @reserve.fair_use.comments.present?
      uls << fair_use_comments
    end

    if @reserve.on_order?
      uls << "<span class=\"text-warning\">On Order</span>"
    end


    if length.present?
      uls << "Clips: #{length}"
    end
    if @reserve.language_track.present?
      uls << "Language: #{@reserve.language_track} <br>"
    end
    if @reserve.subtitle_language.present?
      uls << "Subtitle: #{@reserve.subtitle_language}"
    end

    if @reserve.overwrite_nd_meta_data?
      uls << "Meta Data Manually Entered"
    elsif ReserveMetaDataPolicy.new(@reserve).meta_data_syncronized?
      uls << "Meta Data Synchronized -- #{@reserve.nd_meta_data_id}"
    else
      uls << "Meta Data needs synchronization"
    end

    ret = "<ul>"
    ret += "<li>" + uls.join("</li><li>")
    ret += "</li></ul>"

    ret
  end


  def citation
    simple_format(@reserve.citation)
  end


  def note
    simple_format(@reserve.note)
  end


  def course
    @reserve.course
  end


  def instructor
    @context.link_to(@reserve.course.primary_instructor, @context.new_masquerades_path(:username => @reserve.requestor_netid))
  end


  def requestor
    if @reserve.requestor_name == "imported"
      "Imported"
    else
      link_to(@reserve.requestor_name, @context.new_masquerades_path(:username => @reserve.requestor_netid)) + " - #{@reserve.requestor.email} "
    end
  end



  def number_of_views_for_current_request
    ReserveStat.all_request_stats(@reserve).size
  end


  def number_of_views_all_time
    ReserveStat.all_item_stats(@reserve).size
  end


  def semester_code
    @reserve.semester.code
  end


  private

    def reserve_search
      @search ||= ReserveSearch.new
    end



  def fair_use
    txt = ""
    if !ReserveFairUsePolicy.new(@reserve).requires_fair_use?
      txt = "<span class=\"text-success\">Not Required</span>"
    elsif @reserve.fair_use.update?
      txt = "<span class=\"text-error\">Not Done</span>"
    elsif @reserve.fair_use.approved?
      txt = "<span class=\"text-success\">Approved</span>"
    elsif @reserve.fair_use.denied?
      txt = "<span class=\"text-warning\">Denied</span>"
    elsif @reserve.fair_use.temporary_approval?
      txt = "<span class=\"text-info\">Temporarily Approved</span>"
    else
      raise " Invalid fair use state in admin reserve  "
    end

    txt
  end


  def fair_use_comments
    simple_format(@reserve.fair_use.comments)
  end

end

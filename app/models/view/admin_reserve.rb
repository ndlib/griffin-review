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

  def note
    ret = simple_format(@reserve.note)

    ret
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

  private

    def reserve_search
      @search ||= ReserveSearch.new
    end
end

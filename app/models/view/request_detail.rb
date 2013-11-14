class RequestDetail

  include RailsHelpers

  attr_accessor :reserve

  delegate :workflow_state, :title, :length, :created_at, :course, to: :reserve

  def initialize(controller)
    @controller = controller
    @reserve = reserve_search(@controller.params[:id])

    ReserveCheckInprogress.new(@reserve).check!
  end


  def button
    @button ||= AdminEditButton.new(@reserve)
  end


  def type
    reserve.type.gsub('Reserve', '')
  end


  def citation
    cite = @reserve.citation.to_s.gsub( %r{http://[^\s<]+} ) do |url|
      "<a target=\"_blank\" href='#{url}'>#{url.truncate(100)}</a>"
    end
    helpers.simple_format(cite)
  end


  def special_instructions
    if (@reserve.note.nil? || @reserve.note.empty?)
      "<p class=\"muted\">None</p>"
    else
      helpers.simple_format(@reserve.note)
    end
  end


  def crosslist_and_sections
    "#{@reserve.course.crosslisted_course_ids.join(", ")} - #{@reserve.course.section_numbers.join(", ")}"
  end


  def instructor
    helpers.link_to(@reserve.course.primary_instructor, routes.new_masquerades_path(:username => @reserve.requestor_netid))
  end


  def requestor
    if @reserve.requestor_name == "imported"
      "Imported"
    else
      helpers.link_to(@reserve.requestor_name, routes.new_masquerades_path(:username => @reserve.requestor_netid)) + " - #{@reserve.requestor.email} "
    end
  end



  def number_of_views_for_current_request
    ReserveStat.all_request_stats(@reserve).count
  end


  def number_of_views_all_time
    ReserveStat.all_item_stats(@reserve).count
  end


  def semester_code
    @reserve.semester.code
  end


  def needed_by
    if @reserve.needed_by.nil?
      "Not Entered"
    else
      @reserve.needed_by.to_s(:long)
    end
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

    helpers.raw(txt)
  end


  def fair_use_comments
    helpers.simple_format(@reserve.fair_use.comments)
  end


  private

    def reserve_search(id)
      ReserveSearch.new.get(id)
    end



end

class RequestDetail

  include RailsHelpers

  attr_accessor :reserve

  delegate :workflow_state, :title, :length, :created_at, :course, to: :reserve

  def initialize(controller)
    @controller = controller
    @reserve = reserve_search(@controller.params[:id])

    ReserveCheckInprogress.new(@reserve).check!
  end


  def delete_link
    helpers.link_to(helpers.raw("<i class=\"icon-remove\"></i> Delete Reserve"),
                    routes.course_reserve_path(@reserve.course.id, @reserve.id, redirect_to: 'admin'),
                    data: { confirm: 'Are you sure you wish to remove this reserve from this semester?' },
                    :method => :delete,
                    class: 'btn btn-danger',
                    :id => "delete_reserve_#{@reserve.id}")

  end


  def workflow_state
    if @reserve.workflow_state == 'available'
      css_class = 'text-success'
    elsif @reserve.workflow_state == 'removed'
      css_class = 'text-error'
    else
      css_class = 'text-warning'
    end

    "<span class=\"#{css_class}\">#{@reserve.workflow_state}</span>"
  end



  def citation
    cite = @reserve.citation.to_s.gsub( %r{http://[^\s<]+} ) do |url|
      "<a target=\"_blank\" href='#{url}'>#{url.truncate(100)}</a>"
    end
    helpers.simple_format(cite)
  end


  def special_instructions
    helpers.simple_format(@reserve.note)
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


  def fair_use_comments
    helpers.simple_format(@reserve.fair_use.comments)
  end


  private

    def reserve_search(id)
      ReserveSearch.new.get(id)
    end



end

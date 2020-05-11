class InstructorCourseRow

  attr_accessor :reserve

  delegate :id, :sortable_title, to: :reserve

  def initialize(reserve, controller)
    @reserve = reserve
    @controller = controller
  end


  def row_css_class
    "reserve_#{@reserve.id}"
  end


  def workflow_state
    if @reserve.fair_use.temporary_approval?
      helpers.raw("Temporarily Approved #{helpers.link_to(helpers.image_tag("help.png"), "#temporarily_available_text", 'data-toggle' => "modal")}")
    elsif @reserve.workflow_state == 'available'
      'Published'
    elsif @reserve.workflow_state == "new" || @reserve.workflow_state == 'inprocess'
      'In Process'
    elsif @reserve.workflow_state == "on_order"
      'On Order'
    elsif @reserve.workflow_state == "onhold"
      'On Hold'
    elsif @reserve.workflow_state == "awaitinginfo"
      'Awaiting Information'
    else
      @reserve.workflow_state.titleize
    end
  end


  def can_delete?
    @reserve.workflow_state_events.include?(:remove)
  end


  def can_edit?
    permission.current_user_is_administrator? || permission.current_user_is_admin_in_masquerade?
  end


  def edit_link
    if can_edit?
      helpers.link_to(helpers.raw("<i class=\"icon-edit\"></i>"), routes.request_path(@reserve.id), target: '_blank', title: "Admins: Edit this Reserve")
    else
      ""
    end
  end


  def delete_link
    if can_delete?
      helpers.link_to(helpers.raw("<i class=\"icon-remove\"></i>"),
                      routes.course_reserve_path(@reserve.course.id, @reserve.id),
                      data: { confirm: 'Are you sure you wish to remove this reserve from your course?' },
                      :method => :delete,
                      title: "Delete this Reserve",
                      :id => "delete_reserve_#{@reserve.id}")
    else
      ""
    end
  end


  def delete_sort
    if reserve.removed?
      'removed'
    else
      'available'
    end
  end


  private

    def helpers
      ActionController::Base.helpers
    end


    def routes
      Rails.application.routes.url_helpers
    end


    def permission
      @permission ||= Permission.new(@controller.current_user, @controller)
    end
end


class InstructorCourseRow
  attr_accessor :reserve

  delegate :id, to: :reserve


  def initialize(reserve, context)
    @reserve = reserve
    @context = context
  end


  def row_css_class
    "reserve_#{@reserve.id}"
  end


  def workflow_state
    @reserve.workflow_state.titleize
  end


  def can_delete?
    @reserve.workflow_state_events.include?(:remove)
  end


  def delete_link
    if can_delete?
      @context.link_to(@context.raw("<i class=\"icon-remove\"></i>"),
                     @context.course_reserve_path(@reserve.course.id, @reserve.id),
                      data: { confirm: 'Are you sure you wish to remove this reserve from your course?' },
                      :method => :delete,
                      :id => "delete_reserve_#{@reserve.id}")
    else
      ""
    end
  end

end


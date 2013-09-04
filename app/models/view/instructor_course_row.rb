class InstructorCourseRow

  attr_accessor :reserve

  delegate :id, to: :reserve

  def initialize(reserve)
    @reserve = reserve
  end


  def row_css_class
    "reserve_#{@reserve.id}"
  end


  def workflow_state
    if @reserve.fair_use.temporary_approval?
      helpers.raw("Temporarily Approved #{helpers.link_to(helpers.image_tag("help.png"), "#temporarily_available_text", 'data-toggle' => "modal")}")
    else
      @reserve.workflow_state.titleize
    end
  end


  def can_delete?
    @reserve.workflow_state_events.include?(:remove)
  end


  def delete_link
    if can_delete?
      helpers.link_to(helpers.raw("<i class=\"icon-remove\"></i>"),
                      routes.course_reserve_path(@reserve.course.id, @reserve.id),
                      data: { confirm: 'Are you sure you wish to remove this reserve from your course?' },
                      :method => :delete,
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

end


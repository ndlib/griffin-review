class ReserveCanBeViewedPolicy


  def initialize(reserve, current_user)
    @current_user = current_user
    @reserve = reserve
  end


  def can_be_linked_to?
    can_be_viewed?
  end


  def can_be_viewed?
    resource_completed? && ( current_semester? || user_is_administrator? || instructor_can_preview? ) && !physical_reserve?
  end


  private

    def resource_completed?
      ReserveResourcePolicy.new(@reserve).has_resource?
    end


    def current_semester?
      @reserve.semester.current?
    end


    def user_is_administrator?
      UserIsAdminPolicy.new(@current_user).is_admin?
    end


    def instructor_can_preview?
      @reserve.semester.future? && UserRoleInCoursePolicy.new(@reserve.course, @current_user).user_instructs_course?
    end


    def physical_reserve?
      @reserve.physical_reserve?
    end
end

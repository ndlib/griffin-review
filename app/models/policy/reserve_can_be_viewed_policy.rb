class ReserveCanBeViewedPolicy


  def initialize(reserve, current_user)
    @current_user = current_user
    @reserve = reserve
  end


  def can_be_linked_to?
    can_be_viewed?
  end


  def can_be_viewed?
    electronic_reserve? && resource_completed? && ( current_semester? || user_is_administrator? || instructor_can_preview? )
  end


  private

    def resource_completed?
      ElectronicReservePolicy.new(@reserve).has_resource?
    end


    def current_semester?
      @reserve.course.semester.current?
    end


    def user_is_administrator?
      UserIsAdminPolicy.new(@current_user).is_admin?
    end


    def instructor_can_preview?
      @reserve.semester.future? && UserRoleInCoursePolicy.new(@reserve.course, @current_user).user_instructs_course?
    end


    def electronic_reserve?
      ElectronicReservePolicy.new(@reserve).is_electronic_reserve?
    end
end

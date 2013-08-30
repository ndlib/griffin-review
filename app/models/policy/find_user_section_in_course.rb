class FindUserSectionInCourse


  def initialize(course, user)
    @user = user
    @course = course
  end


  def find
    if UserRoleInCoursePolicy.new(@course, @user).user_instructs_course? || UserIsAdminPolicy.new(@user).is_admin?
      return @course.sections.first
    else
      @course.sections.each do | section |
        if section.enrollment_netids.include?(@user.username)
          return section
        end
      end
    end

    return nil
  end

end

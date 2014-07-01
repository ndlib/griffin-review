class FindUserSectionInCourse


  def initialize(course, user)
    @user = user
    @course = course
  end


  def find
    # finds the students section
    @course.sections.each do | section |
      if section.enrollment_netids.include?(@user.username)
        return section
      end
    end

    # otherwise returns the first section
    return @course.sections.first
  end

end

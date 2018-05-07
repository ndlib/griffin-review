Struct.new("CurrentUser", :username)

class CoursesInReserves
  include RailsHelpers

  attr_accessor :user_course_listing, :netid

  include ModelErrorTrapping

  def initialize(netid)
    @netid = netid
    u = Struct::CurrentUser.new(netid)
    @user_course_listing = ListUsersCourses.new(u)
  end

  def to_hash(options = {})
    {
      netid: netid,
      enrollments: enrollments,
      instructed: instructed_courses,
      currentSemester: Semester.current.first.code,
    }
  end

  private

  def enrollments
    ret = {}
    user_course_listing.enrolled_courses.map do | course |
      ret[course.id] = {
        course_id: course.id,
        title: course.title,
        course_link: routes.course_reserves_url(course.id),
      }
    end
    ret
  end

  def instructed_courses
    ret = {}
    user_course_listing.instructed_courses.map do | course |
      ret[course.id] = {
        course_id: course.id,
        title: course.title,
        course_link: routes.course_reserves_url(course.id),
      }
    end
    ret
  end


end

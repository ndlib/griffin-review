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
      instructor: instructor,
    }
  end

  private

  def enrollments
    user_course_listing.enrolled_courses.collect do | course |
      return {
        course_id: course.id,
        title: course.title,
        has_reserves: (course.reserves.size > 0),
        course_link: routes.course_reserves_url(course.id),
      }
    end
  end

  def instructor
    user_course_listing.instructed_courses.map do | course |
      {
        course_id: course.id,
        title: course.title,
        has_reserves: (course.reserves.size > 0),
        course_link: routes.course_reserves_url(course.id),
        add_reserves_link: routes.new_course_reserve_url(course.id),
      }
    end
  end


end

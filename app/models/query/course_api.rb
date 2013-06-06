class CourseApi

  def enrolled_courses(netid, semester_id)
    load_api_courses(netid, semester_id)
    @result[netid][semester_id]['enrolled_course_objects']
  end


  def instructed_courses(netid, semester_id)
    load_api_courses(netid, semester_id)
    @result[netid][semester_id]['instructed_course_objects']
  end


  def search_courses(search)

  end


  def get(netid, course_id)
    semester_id = Course.get_semester_from(course_id)
    load_api_courses(netid, semester_id)

    (@result[netid][semester_id]['instructed_course_objects'] + @result[netid][semester_id]['enrolled_course_objects']).select { | c | c.id == course_id }.first
  end


  def get_by_section(semester_id, section_id)
    course = API::SearchCourse.course_by_section_id(semester_id, section_id)

    new_course(course)
  end


  private

    def load_api_courses(netid, semester_id)
      @result ||= {}
      @result[netid] ||= {}
      @result[netid][semester_id] ||= false

      if @result[netid][semester_id]
        return @result[netid][semester_id]
      end

      @result[netid][semester_id] = API::Person.courses(netid, semester_id)

      @result[netid][semester_id]['enrolled_course_objects'] = parse_api_result_to_objs(@result[netid][semester_id]['enrolled_courses']) || []
      @result[netid][semester_id]['instructed_course_objects'] = parse_api_result_to_objs(@result[netid][semester_id]['instructed_courses']) || []

      add_course_exceptions(netid, semester_id)
    end


    def parse_api_result_to_objs(api_result)
      result = []

      api_result.each do | c |
        result << new_course(c)
      end

      parse_crosslistings(result)
    end


    def new_course(args)
      Course.factory(args)
    end


    def parse_crosslistings(courses)
      course_to_cross = {}

      courses.each do | c |
        if course_to_cross.has_key?(c.crosslist_id)
          course_to_cross[c.crosslist_id].add_crosslisted_course(c)
        else
          course_to_cross[c.crosslist_id] = c
        end
      end

      course_to_cross.values
    end


    def add_course_exceptions(netid, semester_id)
      UserCourseException.user_course_exceptions(netid, semester_id).each do | course_exception |
        parse_course_exception_to_object(course_exception, netid, semester_id)
      end
    end


    def parse_course_exception_to_object(course_exception, netid, semester_id)
      course = get_by_section(semester_id, course_exception.section_id)

      if course_exception.student?
        @result[netid][semester_id]['enrolled_course_objects'] << course
      elsif course_exception.instructor?
        @result[netid][semester_id]['instructed_course_objects'] << course
      else
        raise "invalid course role"
      end
    end
end

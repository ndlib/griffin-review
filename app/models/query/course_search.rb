class CourseSearch

  def enrolled_courses(netid, semester_id)
    load_api_courses(netid, semester_id)
    @result[netid][semester_id]['enrolled_course_objects']
  end


  def instructed_courses(netid, semester_id)
    load_api_courses(netid, semester_id)
    @result[netid][semester_id]['instructed_course_objects']
  end


  def search(semester_id, search)
    ret = []
    course_api.search(semester_id, search).each do | c |
      c['section_groups'].each do | sg |
        ret << new_course(sg)
      end
    end
    ret
  end


  def all_courses(netid, semester_id)
    load_api_courses(netid, semester_id)
    @result[netid][semester_id]['enrolled_course_objects'].concat(@result[netid][semester_id]['instructed_course_objects'])
  end


  def get(course_id)
    res = course_api.course_id(course_id)
    res = search_for_section_group(res, course_id)

    if res
      return new_course(res)
    else
      return nil
    end
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
        result << new_course(c['section_groups'])
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
      course = self.get(course_exception.section_group_id)

      return if course.nil?

      if course_exception.enrollment?
        @result[netid][semester_id]['enrolled_course_objects'] << course
      elsif course_exception.instructor?
        @result[netid][semester_id]['instructed_course_objects'] << course
      else
        raise "invalid course role"
      end
    end


    def find_section_group_for_netid(res, netid, course_id)
      return false if res.empty?

      res['section_groups'].each do | section_group |

        section_group['sections'].each do | section |
          if section['enrollments'].include?(netid) || section['instructors'].collect{ | s | s['netid']}.include?(netid)
            return section_group
          end
        end
      end

      if UserCourseException.user_course_exceptions(netid, res['section_groups'].first['sections'].first['term']).where(section_group_id: course_id).size > 0
        return res['section_groups'].first
      end

      false
    end


    def search_for_section_group(res, id)
      if !res
        return nil
      end
      if res['section_groups'].is_a?(Hash)
        return res['section_groups']
      else
        res['section_groups'].each do | sg |
          if sg['section_group_id'] == id
            return sg
          end
        end

        return nil
      end
    end

    def course_api
      API::CourseSearchApi
    end
end

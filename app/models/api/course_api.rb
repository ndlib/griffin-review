class CourseApi

  def enrolled_courses(netid, semester_id)
    load_api_courses(netid, semester_id)
    @result[netid][semester_id]['enrolled_course_objects']
  end


  def instructed_courses(netid, semester_id)
    load_api_courses(netid, semester_id)
    reject_duplicates(@result[netid][semester_id]['instructed_course_objects'])
  end


  def search_courses(search)

  end


  def get(netid, course_id)
    semester_id = Course.get_semester_from(course_id)
    load_api_courses(netid, semester_id)

    (@result[netid][semester_id]['instructed_course_objects'] + @result[netid][semester_id]['enrolled_course_objects']).select { | c | c.id == course_id }.first
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
    end


    def parse_api_result_to_objs(api_result)
      result = []

      api_result.each do | c |
        result << new_course(c)
      end
      parse_supersections(result)

      result
    end


    def new_course(args)
      Course.new(args)
    end


    def parse_supersections(courses)
      return courses

      courses.each do | search_course |
        if search_course.has_supersection?
          courses.each do | new_course |
            if search_course.supersection_id == new_course.supersection_id
              search_course.join_to_supersection(new_course)
            end
          end
        end
      end
    end


    def reject_duplicates(courses)
      ret = reject_duplicate_supersections(courses)
      reject_duplicate_cross_listings(ret)
    end


    def reject_duplicate_supersections(courses)
      ret = []
      included_supersection_ids = []
      courses.each do | c |
        if c.has_supersection?
          if !included_supersection_ids.include?(c.supersection_id)
            ret << c
            included_supersection_ids << c.supersection_id
          end
        else
          ret << c
        end
      end

      return ret
    end


    def reject_duplicate_cross_listings(courses)
      return courses
      ret = []
      included_cross_section_ids = []
      courses.each do | c |
        if c.has_cross_listings?
          if !included_cross_section_ids.include?(c.cross_list_id)
            ret << c
            included_cross_section_ids << c.cross_list_id
          end
        else
          ret << c
        end
      end

      return ret
    end
end

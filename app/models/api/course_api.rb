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


  def get(course_id, netid)
    semester_id = Course.get_semester_from(course_id)
    (enrolled_courses(netid, semester_id) + instructed_courses(netid, semester_id)).select { | c | c.id == course_id }.first
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

      @result[netid][semester_id]['enrolled_course_objects'] = parse_api_result_to_objs(@result[netid][semester_id]['enrolled_courses'])
      @result[netid][semester_id]['instructed_course_objects'] = parse_api_result_to_objs(@result[netid][semester_id]['instructed_courses'])
    end


    def parse_api_result_to_objs(api_result)
      result = []

      i = 1
      api_result.each do | c |
        result << new_course(c)
      end

      result
    end


    def new_course(args)
      Course.new(args)
    end
end

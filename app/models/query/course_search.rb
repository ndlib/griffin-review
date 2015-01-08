class CourseSearch

  def enrolled_courses(netid, semester_id)
    load_api_courses(netid, semester_id)
    @result[netid][semester_id]['enrolled_course_objects'].values
  end


  def instructed_courses(netid, semester_id)
    load_api_courses(netid, semester_id)
    @result[netid][semester_id]['instructed_course_objects'].values
  end


  def all_courses(netid, semester_id)
    load_api_courses(netid, semester_id)
    (@result[netid][semester_id]['enrolled_course_objects'].values +  @result[netid][semester_id]['instructed_course_objects'].values)
  end


  def search(semester_id, search)
    massaged_search = massage_search_string(search)
    search_result = course_api.search(semester_id, massaged_search)
    parse_search_to_objects(search_result)
  end



  def get(crosslist_id)
    begin
      if crosslist_id == '12345678_54321_LR'
        parse_crosslist_to_object(crosslist_id, CourseMock.mock_data, true)
      else
        courses = course_api.courses_by_crosslist_id(crosslist_id)
        parse_crosslist_to_object(crosslist_id, courses)
      end
    rescue OpenURI::HTTPError
      parse_crosslist_to_object(crosslist_id, CourseMock.missing_data(crosslist_id), true)

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

      @result[netid][semester_id] = person_course_search(netid, semester_id)

      @result[netid][semester_id]['enrolled_course_objects'] = {}
      parser_user_objects(@result[netid][semester_id]['enrolled_course_objects'], @result[netid][semester_id]['enrolled_courses'])

      @result[netid][semester_id]['instructed_course_objects'] = {}
      parser_user_objects(@result[netid][semester_id]['instructed_course_objects'], @result[netid][semester_id]['instructed_courses'])

      add_course_exceptions(netid, semester_id)
    end


    def parser_user_objects(result_array, json)
      json.each do | section_group |
        course = find_or_create_course(result_array, section_group)
        add_user_sections_to_course(section_group['section_groups']['sections'], course)
      end
    end


    def add_user_sections_to_course(sections, course)
      sections.each do | section |
        course.add_section(section)
      end
    end


    def find_or_create_course(result_array, section_group)
      result_array[section_group['crosslist_id']] ||= new_course(section_group['section_groups'])
    end


    def add_course_exceptions(netid, semester_id)
      UserCourseException.user_exceptions(netid, semester_id).each do | course_exception |
        parse_course_exception_to_object(course_exception, netid, semester_id)
      end
    end


    def parse_course_exception_to_object(course_exception, netid, semester_id)
      course = self.get(course_exception.course_id)

      return if course.nil?

      if course_exception.enrollment?
        @result[netid][semester_id]['enrolled_course_objects'][course.id] = course
      elsif course_exception.instructor?
        @result[netid][semester_id]['instructed_course_objects'][course.id] = course
      else
        raise "invalid course role"
      end
    end


    def parse_crosslist_to_object(crosslist_id, crosslist_json, mock_flag = nil)
      c = nil

      crosslist_json.each do | section_groups |
        section_groups['section_groups'].each do | sections |
        if sections['crosslist_id'] == crosslist_id
          if mock_flag
            c ||= new_course(sections, mock_flag)
          else
            c ||= new_course(sections)
          end
          sections['sections'].each do | section |
              c.add_section(section)
            end
          end
        end
      end

      return c.nil? ? false : c
    end


    def massage_search_string(search)
      search.split(' ').join(' AND ')
    end

    def parse_search_to_objects(search)
      res = []
      search.each do | section_groups |
        section_groups['section_groups'].each do | sections |
          c = new_course(sections)
          sections['sections'].each do | section |
            c.add_section(section) if section.present?
          end
          res << c
        end
      end

      res
    end


    def new_course(section_group, mock_flag = nil)
      if mock_flag
        CourseMock.factory(section_group['crosslist_id'], section_group['primary_instructor'], mock_flag)
      else
        Course.factory(section_group['crosslist_id'], section_group['primary_instructor'])
      end
    end


    def course_api
      API::CourseSearchApi
    end


    def person_course_search(netid, semester_id)
      API::Person.courses(netid, semester_id)
    end
end

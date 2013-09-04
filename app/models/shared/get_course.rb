module GetCourse

  def get_course(id)
    c = course_search.get(id)

    if c.nil?
      raise_404
    end

    c
  end


  def course_search
    @course_search ||= CourseSearch.new
  end

end

module GetCourse

  def get_course(id)
    course_search.get(id)
  end


  def course_search
    @course_search ||= CourseSearch.new
  end

end

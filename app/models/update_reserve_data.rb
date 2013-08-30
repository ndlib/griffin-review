class UpdateReserveData


  def self.process_requests
    Request.all.each do | request |
      if request.course_id != request.crosslist_id
        result = API::CourseSearchApi.course_id(request.course_id)
        new_id = result['section_groups'].first['crosslist_id']

        request.course_id = new_id
        request.save!
      end
    end
  end


  def self.process_exceptions
      UserCourseException.all.each do | exception |
      result = API::CourseSearchApi.course_id(exception.course_id)
      new_id = result['section_groups'].first['crosslist_id']

      exception.course_id = new_id
      exception.save!
    end
  end
end

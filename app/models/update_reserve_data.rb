class UpdateReserveData


  def self.process_requests
    Request.all.each do | request |

      result = API::CourseSearchApi.course_id(request.course_id)
      new_id = result['section_groups'].first['crosslist_id']

      request.course_id = new_id
      request.save!
    end
  end


  def self.process_exceptions
    UserCourseException.all.each do | exception |

      result = API::CourseSearchApi.course_id(exception.section_group_id)
      new_id = result['section_groups'].first['crosslist_id']

      exception.section_group_id = new_id
      exception.save!
    end
  end
end

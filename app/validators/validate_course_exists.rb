class ValidateCourseExists < ActiveModel::Validator
  def validate(record)
    if !course_exits?(record.new_course_id)
      record.errors[:new_course_id] = 'The Course id does not match a known course.'
    end
  end

  def course_exits?(course_id)
    CourseSearch.new.get(course_id).class != CourseMock
  end
end

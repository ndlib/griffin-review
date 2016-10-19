emails = Request.select(:course_id).where("course_id like '201610%'").distinct(:course_id).collect do |r|
  c = CourseSearch.new.get(r.course_id)
  if c.primary_instructor
    c.primary_instructor.email
  end
end.uniq.reject

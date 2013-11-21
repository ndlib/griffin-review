class RequestHeader
  include RailsHelpers

  def initialize(reserve)
    @reserve = reserve
  end

  def title
    ERB::Util.h(@reserve.title)
  end

  def type
    ERB::Util.h(@reserve.type.gsub('Reserve', ''))
  end


  def crosslist_and_sections
    "#{@reserve.course.crosslisted_course_ids.join(", ")} - #{@reserve.course.section_numbers.join(", ")}"
  end


  def course_link
    helpers.link_to @reserve.course.title, routes.course_reserves_path(@reserve.course.id)
  end
end

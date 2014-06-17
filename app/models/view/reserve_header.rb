class ReserveHeader
  include RailsHelpers

  def initialize(reserve)
    @reserve = reserve
  end

  def title
    ERB::Util.h(@reserve.title)
  end

  def course_link
    helpers.link_to @reserve.course.title, routes.course_reserves_path(@reserve.course.id)
  end

end

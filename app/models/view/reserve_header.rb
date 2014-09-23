class ReserveHeader
  include RailsHelpers

  attr_accessor :reserve
  delegate :id, :file, :url, :title, :length, :course , :details, :publisher_provider, :realtime_availability_id, to: :reserve

  def initialize(reserve)
    @reserve = reserve
  end

  def title
    ERB::Util.h(reserve.title)
  end

  def creator_contributor
    "#{@reserve.creator_contributor}#{(@reserve.creator_contributor.present? ? '<br>' : '')}"
  end

  def course_link
    helpers.link_to reserve.course.title, routes.course_reserves_path(reserve.course.id)
  end

end

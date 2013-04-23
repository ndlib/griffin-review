class RequestReserve
  attr_accessor :course, :current_user

  def initialize(course, current_user)
    @course = course
    @current_user = current_user
  end


end

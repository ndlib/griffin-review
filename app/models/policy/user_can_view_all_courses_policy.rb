class UserCanViewAllCoursesPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def can_view_all_courses?
    user.username == 'circ'
  end
end

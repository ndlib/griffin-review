module ApplicationHelper

  def user_top_nav()
    render partial: '/layouts/user_nav',
                locals: { user_course_listing: UserCourseListing.new(current_user) }
  end


end

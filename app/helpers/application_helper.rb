module ApplicationHelper

  def user_top_nav()
    render partial: '/layouts/user_nav',
                locals: { user_course_listing: UserCourseListing.new(current_user) }
  end


  def breadcrumb(*crumbs)
    crumbs.unshift(link_to("Hesburgh Libraries", "https://www.library.nd.edu"))
    content_for(:breadcrumb, raw(crumbs.join(" &gt; ")))
  end
end

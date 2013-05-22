module ApplicationHelper

  def user_top_nav()
    render partial: '/layouts/user_nav',
                locals: { user_course_listing: UserCourseListing.new(current_user) }
  end


  def library_select_form(f)
    f.input :library, as: "select", collection: [ 'Hesburgh', 'Math', 'Chemestry/Physics', 'BIC', 'Architecture', 'Engeneering'], :selected => 'Hesburgh'
  end
end

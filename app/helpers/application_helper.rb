module ApplicationHelper

  def url_for(options = {})
    original = super(options)
    return original unless (request.path.starts_with?('/sakai') && !original.starts_with?('/sakai'))
    original.gsub(/^\//, '/sakai/')
  end


  def user_top_nav()
    render partial: '/layouts/user_nav',
      locals: { user_course_listing: UserCourseListing.new(current_user) }
  end


  def sakai_top_nav
    render partial: '/layouts/sakai_nav',
                locals: { user_course_listing: UserCourseListing.new(current_user) }
  end


  def library_select_form(f)
    f.input :library, as: "select", collection: { 'Hesburgh Library' => :hesburgh , 'O\' Meara Mathmatics Library' => :math, 'Chemestry - Physics Library' => :chem, 'Mahaffey Business Library' => :business, 'Architecture Library' => :architecture, 'Engeneering Library' => :engeneering }, :selected => 'Hesburgh'
  end


  def permission
    @permission ||= Permission.new(current_user, self)
  end


  def masquerade
    @masquerade ||= Masquerade.new(self)
  end


  def new_instructor_reserve(type)
    if @request_reserve && @request_reserve.type == type
      return @request_reserve
    else
      @new_reserve
    end
  end
end

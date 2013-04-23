class GetCourseListing
  attr_accessor :course_lising, :current_user

  def initialize(course_listing, current_user)
    @course_listing = course_listing
    @current_user = current_user
    @term_of_service_approved = false
  end


  def approval_required?
    @course_listing.approval_required? && !term_of_service_approved?
  end


  def term_of_service_approved?
    @term_of_service_approved
  end


  def approve_terms_of_service!
    @term_of_service_approved = true
  end


  def download_listing?
    @course_listing.file.present?
  end


  def redirect_to_listing?
    redirect_uri.present?
  end


  def download_file_path
    "#{Rails.root}#{@course_listing.file}"
  end


  def redirect_uri
    @course_listing.url
  end

end

class GetReserve

  attr_accessor :reserve, :current_user, :term_of_service_approved

  def initialize(reserve, current_user)
    @reserve = reserve
    @current_user = current_user
    @term_of_service_approved = false
  end


  def approval_required?
    @reserve.approval_required? && !term_of_service_approved?
  end


  def term_of_service_approved?
    @term_of_service_approved
  end


  def approve_terms_of_service!
    @term_of_service_approved = true
  end


  def download_listing?
    @reserve.file.present?
  end


  def redirect_to_listing?
    redirect_uri.present?
  end


  def download_file_path
    "#{Rails.root}/#{@reserve.file}"
  end


  def redirect_uri
    @reserve.url
  end

end

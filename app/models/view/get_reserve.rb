class GetReserve
  include ModelErrorTrapping
  include GetCourse

  attr_accessor :reserve, :current_user, :term_of_service_approved

  def initialize(current_user, params)
    @current_user = current_user
    @reserve = get_course(params[:course_id]).reserve(params[:id])

    @term_of_service_approved = false

    validate_input!
  end


  def course
    @reserve.course
  end


  def approval_required?
    reserve_requires_approval? && !term_of_service_approved?
  end


  def term_of_service_approved?
    @term_of_service_approved
  end


  def approve_terms_of_service!
    @term_of_service_approved = true
  end


  def download_listing?
    ReserveResourcePolicy.new(@reserve, @current_user).has_file_resource?
  end


  def redirect_to_listing?
    redirect_uri.present?
  end


  def reserve_in_current_semester?
    @reserve.semester.current?
  end


  def link_to_listing?
    ReserveResourcePolicy.new(@reserve, @current_user).can_be_linked_to?
  end


  def download_file_path
    ReserveResourcePolicy.new(@reserve, @current_user).reserve_file_path
  end


  def redirect_uri
    @reserve.url
  end


  def streaming_server_file?
    ReserveResourcePolicy.new(@reserve, @current_user).streaming_service_resource?
  end


  def mov_file_path
    MovFileGenerator.new(@reserve).mov_file_path
  end


  private

    def validate_input!
      if !link_to_listing?
        render_404
      end
    end


    def reserve_requires_approval?
      ReserveRequiresTermsOfServiceAgreement.new(reserve).requires_agreement?
    end
end


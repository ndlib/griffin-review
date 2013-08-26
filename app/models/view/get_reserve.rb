require 'digest/md5'

class GetReserve
  include ModelErrorTrapping
  include GetCourse

  attr_accessor :reserve, :current_user, :term_of_service_approved

  def initialize(current_user, params)
    @current_user = current_user
    @reserve = reserve_search.get(params[:id])

    @term_of_service_approved = false

    validate_input!(params)
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
    ReserveResourcePolicy.new(@reserve).has_file_resource?
  end


  def redirect_to_listing?
    redirect_uri.present?
  end


  def link_to_listing?
    ReserveCanBeViewedPolicy.new(@reserve, @current_user).can_be_viewed?
  end


  def download_file_path
    ReserveResourcePolicy.new(@reserve).reserve_file_path
  end


  def redirect_uri
    @reserve.url
  end


  def streaming_server_file?
    rp = ReserveResourcePolicy.new(@reserve)
    rp.streaming_service_resource? && !rp.streaming_service_redirect?
  end


  def mov_file_path
    MovFileGenerator.new(@reserve).mov_file_path
  end


  def mark_view_statistics
    ReserveStat.add_statistic!(current_user, @reserve)
  end


  def get_course_token
    Digest::MD5.hexdigest("#{Date.today}-#{course.id}")
  end


  private

    def validate_input!(params)
      if params[:course_id] != @reserve.course.id
        render_404
      end

      if !current_user.nil? && !link_to_listing?
        render_404
      end
    end


    def reserve_requires_approval?
      ReserveRequiresTermsOfServiceAgreement.new(reserve).requires_agreement?
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end
end


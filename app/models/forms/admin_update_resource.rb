class AdminUpdateResource
  include Virtus
  include ModelErrorTrapping

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve

  attribute :pdf, String
  attribute :url, String

  delegate :workflow_state, :id, to: :reserve


  validate :pdf_cannot_have_a_value, :url_cannot_have_a_value


  def initialize(current_user, params)
    @reserve = reserve_search.get(params[:id], nil)
    @current_user = current_user

    if params[:admin_update_resource]
      self.attributes = params[:admin_update_resource]
    else
      self.url = @reserve.url
    end

    validate_input!

    ReserveCheckInprogress.new(@reserve).check!
  end


  def show_file_upload_form?
    ReserveResourcePolicy.new(reserve).can_have_file_resource?
  end


  def show_url_form?
    ReserveResourcePolicy.new(reserve).can_have_url_resource?
  end


  def show_video_form?
    ReserveResourcePolicy.new(reserve).streaming_service_resource?
  end


  def steaming_server_full_url?
    show_video_form? && TextIsUriPolicy.uri?(reserve.url)
  end


  def save_resource
    if valid?
      persist!
      true
    else
      false
    end
  end


  def pdf_file_name
    @reserve.item.pdf_file_name
  end


  private

    def validate_input!
      fp = ReserveResourcePolicy.new(@reserve)
      up = ReserveResourcePolicy.new(@reserve)

      if !fp.can_have_file_resource? && !up.can_have_url_resource?
        raise_404
      end
    end

    def persisted?
      false
    end


    def persist!
      @reserve.pdf = pdf
      @reserve.url = url

      @reserve.save!
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end


    def pdf_cannot_have_a_value
      policy = ReserveResourcePolicy.new(@reserve)
      if !policy.can_have_file_resource? && pdf.present?
        errors.add(:pdf, "can't upload a file for this type.")
      end
    end


    def url_cannot_have_a_value
      policy = ReserveResourcePolicy.new(@reserve)
      if !policy.can_have_url_resource? && url.present?
        errors.add(:url, "can't add a url for this type.")
      end
    end

end

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

    if params[:admin_update_resource]
      self.attributes = params[:admin_update_resource]
    end

    validate_input!

    ensure_state_is_inprogress!
  end


  def show_file_upload_form?
    ReserveFileResourcePolicy.new(reserve).can_have_file_resource?
  end


  def show_url_form?
    ReserveUrlResourcePolicy.new(reserve).can_have_url_resource?
  end


  def save_resource
    if valid?
      persist!
      true
    else
      false
    end
  end


  private

    def validate_input!
      fp = ReserveFileResourcePolicy.new(@reserve)
      up = ReserveUrlResourcePolicy.new(@reserve)

      if !fp.can_have_file_resource? && !up.can_have_url_resource?
        render_404
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


    def ensure_state_is_inprogress!
      reserve.ensure_state_is_inprogress!
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end


    def pdf_cannot_have_a_value
      policy = ReserveFileResourcePolicy.new(@reserve)
      if !policy.can_have_file_resource? && pdf.present?
        errors.add(:pdf, "can't upload a file for this type.")
      end
    end


    def url_cannot_have_a_value
      policy = ReserveUrlResourcePolicy.new(@reserve)
      if !policy.can_have_url_resource? && url.present?
        errors.add(:url, "can't add a url for this type.")
      end
    end



end

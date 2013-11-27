class AdminUpdateResource
  include RailsHelpers
  include Virtus
  include ModelErrorTrapping

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve

  attribute :pdf, String
  attribute :url, String

  delegate :workflow_state, :id, to: :reserve


  def initialize(current_user, params)
    @reserve = reserve_search.get(params[:id], nil)
    @current_user = current_user

    if params[:admin_update_resource]
      self.attributes = params[:admin_update_resource]
    end

    validate_input!

    check_is_complete!
  end


  def has_resource?
    electronic_reserve.has_resource?
  end


  def current_resource_type
    electronic_reserve.electronic_resource_type
  end


  def current_resource_name
    electronic_reserve.resource_name
  end


  def delete_link
    DeleteReserveElectronicResourceForm.new(@reserve).delete_link
  end


  def default_to_streaming?
    @reserve.type == 'VideoReserve' || @reserve.type == 'AudioReserve'
  end


  def sipx_button
    helpers.link_to(helpers.raw("<i class=\"icon icon-arrow-up\"></i> Go To Sipx</a>"), routes.course_sipx_admin_redirect_path(course.id), class: "btn", target: "_blank")
  end

  def course
    @reserve.course
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

    def check_is_complete!
      ReserveCheckInprogress.new(@reserve).check!
    end


    def validate_input!
      if !electronic_reserve.is_electronic_reserve?
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

      ReserveCheckIsComplete.new(@reserve).check!
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end


    def electronic_reserve
      @epolicy ||= ElectronicReservePolicy.new(@reserve)
    end

end

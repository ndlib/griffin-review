class AdminUpdateResource
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve

  attribute :file, String
  attribute :url, String

  delegate :workflow_state, :id, to: :reserve

  def initialize(current_user, params)
    @reserve = reserve_search.get(params[:id], nil)

    if params[:admin_reserve]
      self.attributes = params[:admin_reserve]
    end

    ensure_state_is_inprogress!
  end


  def show_file_upload_form?
    ReserveFileResourcePolicy.new(reserve).can_have_file_resource?
  end


  def show_url_form?
    ReserveUrlResourcePolicy.new(reserve).can_have_url_resource?
  end


  private

    def persisted?
      false
    end

    def ensure_state_is_inprogress!
      reserve.ensure_state_is_inprogress!
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end




end

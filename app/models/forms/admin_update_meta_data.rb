class AdminUpdateMetaData
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve

  attribute :title, String
  attribute :creator, String
  attribute :details, String
  attribute :publisher, String
  attribute :journal_title, String
  attribute :nd_meta_data_id, String

  validates :nd_meta_data_id, presence: true, if: :requires_nd_meta_data_id?
  validates :title, :creator, :journal_title, presence: true, unless: :requires_nd_meta_data_id?

  delegate :workflow_state, :semester, :type, :creator_contributor, :publisher_provider, to: :reserve

  def initialize(current_user, params)
    @reserve = reserve_search.get(params[:id], nil)

    if params[:admin_reserve]
      self.attributes = params[:admin_reserve]
    end

    @reserve.ensure_state_is_inprogress!
  end


  def reserve_id
    @reserve.id
  end


  def persisted?
    false
  end


  def save_meta_data
    if valid?
      persist!
      true
    else
      false
    end
  end


  def reserve
    @reserve
  end


  private

    def requires_nd_meta_data_id?
      (!reserve.overwrite_nd_meta_data?)
    end


    def persist!
      @reserve.check_set_complete!
      @reserve.save!

      ReserveCheckIsComplete.new(@reserve).check!
    end


    def verify_ils_system_id
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end

end

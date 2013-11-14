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
  attribute :length, String
  attribute :nd_meta_data_id, String
  attribute :display_length, String
  attribute :on_order, Boolean
  attribute :overwrite_nd_meta_data, Boolean

  validates :nd_meta_data_id, presence: true, if: :requires_nd_meta_data_id?
  validates :title, presence: true, unless: :requires_nd_meta_data_id?

  validates_with ValidateMetaDataId, if: :requires_nd_meta_data_id?


  delegate :id, :workflow_state, :semester, :type, :creator_contributor, :publisher_provider, to: :reserve

  def initialize(current_user, params)
    @reserve = reserve_search.get(params[:id], nil)

    self.attributes.each_key do |key|
      self.send("#{key}=", @reserve.send(key))
    end

    if params[:admin_update_meta_data]
      self.attributes = params[:admin_update_meta_data]
      self.nd_meta_data_id = self.nd_meta_data_id.strip
    end

    self.overwrite_nd_meta_data ||= false

    ReserveCheckInprogress.new(@reserve).check!
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


  def overwrite_nd_meta_data?
    overwrite_nd_meta_data
  end


  private

    def requires_nd_meta_data_id?
      (!overwrite_nd_meta_data?)
    end


    def persist!
      @reserve.attributes = self.attributes

      @reserve.save!

      synchronize_meta_data!

      ReserveCheckIsComplete.new(@reserve).check!
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end


    def synchronize_meta_data!
      if requires_nd_meta_data_id?
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
      end
    end

end


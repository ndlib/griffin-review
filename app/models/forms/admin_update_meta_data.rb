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
  attribute :display_length, String
  attribute :on_order, Boolean
  attribute :overwrite_nd_meta_data, Boolean

  validates :nd_meta_data_id, presence: true, if: :requires_nd_meta_data_id?
  validates :title, presence: true, unless: :requires_nd_meta_data_id?
#  validates :journal_title, presence: true,  if: :requires_journal_title?

  delegate :id, :workflow_state, :semester, :type, :creator_contributor, :publisher_provider, to: :reserve

  def initialize(current_user, params)
    @reserve = reserve_search.get(params[:id], nil)

    self.attributes.each_key do |key|
      self.send("#{key}=", @reserve.send(key))
    end

    if params[:admin_update_meta_data]
      self.attributes = params[:admin_update_meta_data]
    end

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
    reserve.overwrite_nd_meta_data?
  end

  private

    def requires_nd_meta_data_id?
      (!overwrite_nd_meta_data)
    end


    def requires_journal_title?
    #  @reserve.type == 'JournalReserve'
    end


    def persist!
      @reserve.attributes = self.attributes

      @reserve.save!

      ReserveSynchronizeMetaData.new(@reserve, true).check_synchronized!
    end


    def verify_ils_system_id
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end

end

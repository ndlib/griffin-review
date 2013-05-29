class AdminUpdateMetaData
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations


  attribute :title, String
  attribute :creator, String
  attribute :journal_title, String
  attribute :nd_meta_data_id, String

  validates :nd_meta_data_id, presence: true, if: :requires_nd_meta_data_id?
  validates :title, :creator, :journal_title, presence: true, unless: :requires_nd_meta_data_id?

  def initialize(reserve, request_attributes = {})
    @reserve = reserve
    self.attributes = request_attributes

    ensure_state_is_inprogress!
  end


  def persisted?
    false
  end


  def save_meta_data
    if valid?
      puts @reserve.class
      @reserve.save!
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


    def ensure_state_is_inprogress!
      reserve.ensure_state_is_inprogress!
    end


    def persist!
      puts @reserve.class

    end


    def verify_ils_system_id
    end

end

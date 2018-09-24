class AdminUpdateMetaData
  include Virtus
  include VirtusFormHelpers
  include RailsHelpers

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve

  attribute :title, String
  attribute :creator, String
  attribute :contributor, String
  attribute :details, String
  attribute :publisher, String
  attribute :journal_title, String
  attribute :length, String
  attribute :nd_meta_data_id, String
  attribute :overwrite_nd_meta_data, Boolean
  attribute :selection_title, String

  #validates :nd_meta_data_id, presence: true, if: :requires_nd_meta_data_id?
  validates :title, presence: true, unless: :requires_nd_meta_data_id?

  validates_with ValidateMetaDataId, if: :test_meta_data_id?

  delegate :id, :workflow_state, :semester, :type, :creator_contributor, :publisher_provider, to: :reserve


  def self.build_from_params(controller)
    reserve = ReserveSearch.new.get(controller.params[:id])
    self.new(reserve, controller.params[:admin_update_meta_data])
  end


  def initialize(reserve, params)
    @reserve = reserve

    set_attributes_from_model(reserve)

    fix_params(params)
    set_attributes_from_params(params)

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


  def title_field_name
    if @reserve.type == 'BookReserve' || @reserve.type == 'BookChapterReserve'
      "Book Title"
    elsif @reserve.type == 'JournalReserve'
      "Article Title"
    elsif @reserve.type == 'VideoReserve'
      "Video Title"
    else
      "Title"
    end
  end


  def catalog_search_href
    search_term = CGI.escape(@reserve.title)
    if @reserve.type == 'VideoReserve'
      "http://onesearch.library.nd.edu/primo-explore/search?query=title,contains,#{search_term},AND&pfilter=pfilter,exact,videos,AND&tab=nd_campus&search_scope=nd_campus&sortby=rank&vid=NDU&lang=en_US&mode=advanced&offset=0&fromRedirectFilter=true"
    elsif @reserve.type == 'AudioReserve'
      "http://onesearch.library.nd.edu/primo-explore/search?query=title,contains,#{search_term},AND&pfilter=pfilter,exact,audio,AND&tab=nd_campus&search_scope=nd_campus&sortby=rank&vid=NDU&lang=en_US&mode=advanced&offset=0&fromRedirectFilter=true"
    elsif @reserve.type == 'BookReserve' || @reserve.type == 'BookChapterReserve'
      "http://onesearch.library.nd.edu/primo-explore/search?query=title,contains,#{search_term},AND&pfilter=pfilter,exact,books,AND&tab=nd_campus&search_scope=nd_campus&sortby=rank&vid=NDU&lang=en_US&mode=advanced&offset=0&fromRedirectFilter=true"
    elsif @reserve.type == 'JournalReserve'
      "http://onesearch.library.nd.edu/primo-explore/search?query=title,contains,#{search_term},AND&pfilter=pfilter,exact,journals,AND&tab=nd_campus&search_scope=nd_campus&sortby=rank&vid=NDU&lang=en_US&mode=advanced&offset=0&fromRedirectFilter=true"
    else
      ""
    end
  end


  def instructor_notes
    ReserveInstructorNotes.new(@reserve).display
  end


  def resync_button
    ResyncReserveButton.new(@reserve).button
  end

  private

    def requires_nd_meta_data_id?
      ReserveMetaDataPolicy.new(@reserve).meta_data_id_required?
    end


    def test_meta_data_id?
      nd_meta_data_id.present?
    end


    def persist!
      @reserve.attributes = self.attributes
      @reserve.reviewed = true

      @reserve.save!

      synchronize_meta_data!

      ReserveCheckIsComplete.new(@reserve).check!
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end


    def synchronize_meta_data!
      if @reserve.nd_meta_data_id.present? && @reserve.metadata_synchronization_date.nil?
        ReserveSynchronizeMetaData.new(@reserve).synchronize!
      end
    end


    def fix_params(params)
      if params && params[:nd_meta_data_id].present?
        params[:nd_meta_data_id].strip!
        params[:nd_meta_data_id] = params[:nd_meta_data_id].gsub(/^ndu_aleph/, '').rjust(9, "0")
      end
    end
end

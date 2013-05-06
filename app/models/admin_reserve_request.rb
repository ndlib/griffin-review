class AdminReserveRequest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :reserve, :current_user


  delegate :title, :journal_title, :length, :file, :url, :course, :id, :note, :citation, :comments, :article_details, :to => :reserve
  delegate :requestor_owns_a_copy, :number_of_copies, :creator, :needed_by, :requestor_has_an_electronic_copy, :to => :reserve
  delegate :length, :discovery_id, :library, :publisher, :requestor, :status, :creator_contributor, :css_class, :link_to_get_listing?, :to => :reserve
  delegate :details, :publisher_provider, :available_library, :is_available?, :availability, :type, :to => :reserve


  def initialize(reserve, current_user)
    @reserve = reserve
    @current_user = current_user
  end


  def needs_meta_data?
    !has_nd_record_id? && !has_internal_metadata?
  end


  def has_nd_record_id?
    self.discovery_id.present?
  end


  def has_internal_metadata?
    false
  end


  def needs_external_source?
    (can_have_uploaded_file? || can_have_url?) && !(self.file.present? || self.url.present?)
  end


  def can_have_uploaded_file?
    [BookChapterReserve, JournalReserve].include?(@reserve.class)
  end


  def can_have_url?
    [JournalReserve, VideoReserve, AudioReserve].include?(@reserve.class)
  end


  def data_complete?
    !needs_meta_data? && !needs_external_source?
  end


  def persisted?
    false
  end
end

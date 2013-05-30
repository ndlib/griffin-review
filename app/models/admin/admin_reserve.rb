class AdminReserve
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :reserve

  delegate :title, :journal_title, :length, :file, :url, :course, :id, :note, :citation, :comments, :article_details, :to => :reserve
  delegate :requestor_owns_a_copy, :number_of_copies, :creator, :needed_by, :requestor_has_an_electronic_copy, :to => :reserve
  delegate :length, :nd_meta_data_id, :library, :publisher, :requestor, :workflow_state, :creator_contributor, :css_class, :link_to_get_listing?, :to => :reserve
  delegate :fair_use, :details, :publisher_provider, :available_library, :is_available?, :availability, :type, :to => :reserve

  delegate :save!, to: :reserve
  delegate :ensure_state_is_inprogress!, :overwrite_nd_meta_data=, :overwrite_nd_meta_data, :overwrite_nd_meta_data?, to: :reserve


  def initialize(reserve)
    @reserve = reserve
  end


  def data_complete?
    !needs_meta_data? && !needs_external_source? && !needs_fair_use?
  end


  def needs_external_source?
    (can_have_uploaded_file? || can_have_url?) && !(self.file.present? || self.url.present?)
  end


  def can_have_external_resource?
    can_have_uploaded_file? || can_have_url?
  end


  def can_have_uploaded_file?
    ['BookChapterReserve', 'JournalReserve'].include?(@reserve.type)
  end


  def can_have_url?
    ['JournalReserve', 'VideoReserve', 'AudioReserve'].include?(@reserve.type)
  end


  def needs_meta_data?
    !has_nd_record_id? && !has_internal_metadata?
  end


  def has_nd_record_id?
    self.nd_meta_data_id.present?
  end


  def has_internal_metadata?
    false
  end


  def needs_fair_use?
    if should_have_fair_use?
      return self.fair_use.nil?
    end

    return false
  end


  def should_have_fair_use?
    return true if ['BookChapterReserve', 'VideoReserve', 'AudioReserve'].include?(@reserve.type)

    return true if 'JournalReserve' == @reserve.type && @reserve.file.present?

    return false
  end


  def fair_use_display
    if should_have_fair_use?
      if needs_fair_use?
        return "<span class=\"missing_text\">Not Done</span>"
      else
        return "<span class=\"complete_text\">Yes</span>"
      end
    else
      return "<span class=\"complete_text\">Not Required</span>"
    end
  end




  def persisted?
    false
  end

end

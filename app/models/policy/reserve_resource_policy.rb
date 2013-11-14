class ReserveResourcePolicy

  def initialize(reserve)
    @reserve = reserve
  end


  def can_have_resource?
    (can_have_file_resource? || can_have_url_resource?)
  end


  def can_have_file_resource?
    return true if ['JournalReserve', 'BookChapterReserve'].include?(@reserve.type) && !physical_reserve_only?


    false
  end


  def has_file_resource?
    can_have_file_resource? && @reserve.pdf.present?
  end


  def reserve_file_path
    @reserve.pdf.path
  end


  def can_have_url_resource?
    return true if ['BookChapterReserve', 'JournalReserve', 'VideoReserve', 'AudioReserve'].include?(@reserve.type) && !physical_reserve_only?

    false
  end


  def streaming_service_resource?
    ['VideoReserve', 'AudioReserve'].include?(@reserve.type)
  end


  def streaming_service_redirect?
    TextIsUriPolicy.uri?(@reserve.url)
  end


  def has_url_resource?
    can_have_url_resource? && @reserve.url.present?
  end


  def has_resource?
    has_url_resource? || has_file_resource?
  end


  def complete?
    !can_have_resource? || has_resource?
  end


  def physical_reserve_only?
    PhysicalReserve.new(@reserve).is_physical_reserve? && !ElectronicReserve.new(@reserve).is_electronic_reserve?
  end
end

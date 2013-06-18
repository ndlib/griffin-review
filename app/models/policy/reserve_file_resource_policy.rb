class ReserveFileResourcePolicy

  def initialize(reserve)
    @reserve = reserve
  end


  def can_have_file_resource?
    return true if ['JournalReserve', 'BookChapterReserve'].include?(@reserve.type)

    false
  end


  def has_file_resource?
    can_have_file_resource? && @reserve.pdf.present?
  end


  def reserve_file_path
    @reserve.pdf.path
  end


end

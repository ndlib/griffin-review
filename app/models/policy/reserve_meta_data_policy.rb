class ReserveMetaDataPolicy

  def initialize(reserve)
    @reserve = reserve
  end


  def uses_internal_metadata?
    false
  end


  def meta_data_needs_to_be_synchronized?
    false
  end


  def complete?
    @reserve.nd_meta_data_id.present? && !uses_internal_metadata?
  end

end

class ReserveMetaDataPolicy

  def initialize(reserve)
    @reserve = reserve
  end


  def meta_data_syncronized?
    @reserve.nd_meta_data_id.present?
  end


  def complete?
    @reserve.nd_meta_data_id.present? || @reserve.overwrite_nd_meta_data?
  end
end

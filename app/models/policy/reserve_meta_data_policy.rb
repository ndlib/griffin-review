class ReserveMetaDataPolicy

  def initialize(reserve)
    @reserve = reserve
  end


  def meta_data_syncronized?
    @reserve.nd_meta_data_id.present?
  end


  def meta_data_id_required?
    PhysicalReservePolicy.new(@reserve).is_physical_reserve?
  end


  def meta_data_reviewed?
    true
  end


  def complete?
    if (meta_data_id_required?)
      return @reserve.nd_meta_data_id.present?
    else
      return meta_data_reviewed?
    end
  end
end

class AdminEditButton


  def initialize(reserve)
    @reserve = reserve
  end


  def reserve_id
    @reserve.id
  end


  def complete?
    fair_use_complete? && meta_data_complete? &&  external_resouce_comeplete?
  end


  def meta_data_complete?
    ReserveMetaDataPolicy.new(@reserve).has_meta_data?
  end


  def meta_data_css_class
    meta_data_complete? ? 'icon-ok' : ''
  end


  def requires_external_resource?
    ReserveFileResourcePolicy.new(@reserve).can_have_file_resource? ||
    ReserveUrlResourcePolicy.new(@reserve).can_have_url_resource?
  end


  def external_resouce_comeplete?
    ReserveFileResourcePolicy.new(@reserve).has_file_resource? ||
    ReserveUrlResourcePolicy.new(@reserve).has_url_resource?
  end


  def external_resource_css_class
    external_resouce_comeplete? ? 'icon-ok' : ''
  end


  def requires_fair_use?
    ReserveFairUsePolicy.new(@reserve).requires_fair_use?
  end


  def fair_use_complete?
    ReserveFairUsePolicy.new(@reserve).fair_use_complete?
  end


  def fair_use_css_class
    fair_use_complete? ? 'icon-ok' : ''
  end


end

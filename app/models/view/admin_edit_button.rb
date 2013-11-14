class AdminEditButton


  def initialize(reserve)
    @reserve = reserve
  end


  def reserve_id
    @reserve.id
  end


  def removed?
    @reserve.workflow_state == 'removed'
  end


  def meta_data_notes
    # record id required  - physical no id
    # sychronized on: date  ndu_aleph23423423424 - if id
    # requires review. - no physical no review
    # meta data manually entered - no phys review no id
  end


  def electronic_resource_notes
    uls = []
    if requires_external_resource?
      if external_resouce_comeplete?
        uls << "Streaming Video"
      else
        uls << "Requires: Streaming Video"
      end
    else
      uls << "Not Required"
    end
  end


  def fair_use_notes
    uls = []
    if requires_fair_use?
      if fair_use_complete?
        uls << @reserve.fair_use.state.titleize
      else
        uls << "Requires: Completion"
      end
    else
      uls << "Not Required"
    end
  end


  def complete?
    ReserveCheckIsComplete.new(@reserve).complete?
  end


  def meta_data_complete?
    ReserveMetaDataPolicy.new(@reserve).complete?
  end


  def meta_data_css_class
    meta_data_complete? ? 'icon-ok' : ''
  end


  def requires_external_resource?
    ReserveResourcePolicy.new(@reserve).can_have_resource?
  end


  def external_resouce_comeplete?
    ReserveResourcePolicy.new(@reserve).has_resource?
  end


  def external_resource_css_class
    external_resouce_comeplete? ? 'icon-ok' : ''
  end


  def requires_fair_use?
    ReserveFairUsePolicy.new(@reserve).requires_fair_use?
  end


  def fair_use_complete?
    ReserveFairUsePolicy.new(@reserve).complete?
  end


  def fair_use_css_class
    fair_use_complete? ? 'icon-ok' : ''
  end


end

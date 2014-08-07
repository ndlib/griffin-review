class RequestEditNav

  include RailsHelpers

  def initialize(reserve)
    @reserve = reserve
  end


  def reserve_id
    @reserve.id
  end


  def removed?
    @reserve.workflow_state == 'removed'
  end


  def on_order_form
    PlaceItemOnOrderForm.new(@reserve)
  end


  def meta_data_notes
    uls = []
    if @reserve.nd_meta_data_id.present?
      uls << "Record ID: #{@reserve.nd_meta_data_id}"
      uls << "Syncronized on #{@reserve.metadata_synchronization_date.to_s(:long)}"

    elsif meta_data_policy.meta_data_id_required? && !meta_data_policy.complete?
      uls << "Requires a Record ID"
    else
      if meta_data_policy.complete?
        uls << "Meta Data Not Syncronized."
      else
        uls << "Requires Meta Data Review <br> Go to the meta data page and review it and click save."
      end
    end

    if physical_reserve? && !reserve_in_aleph?
      uls << "This reserve has not been found in the nightly aleph export.  Make sure it has been entered into aleph."
    end

    return uls
  end


  def electronic_resource_notes
    uls = []
    if requires_electronic_resource?
      if electronic_resouce_comeplete?
        erpolicy = ElectronicReservePolicy.new(@reserve)
        uls << "#{erpolicy.electronic_resource_type}: #{erpolicy.resource_name.truncate(40)}"
      else
        uls << "Requires an Electronic Resource"
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
        uls << "Requires Form Completion"
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


  def requires_electronic_resource?
    ElectronicReservePolicy.new(@reserve).can_have_resource?
  end


  def electronic_resouce_comeplete?
    ElectronicReservePolicy.new(@reserve).complete?
  end


  def requires_fair_use?
    ReserveFairUsePolicy.new(@reserve).requires_fair_use?
  end


  def fair_use_complete?
    ReserveFairUsePolicy.new(@reserve).complete?
  end


  def physical_reserve?
    PhysicalReservePolicy.new(@reserve).is_physical_reserve?
  end


  def reserve_in_aleph?
    ReserveInAlephPolicy.new(@reserve).in_aleph?
  end

  private

    def meta_data_policy
      @policy ||= ReserveMetaDataPolicy.new(@reserve)
    end



end

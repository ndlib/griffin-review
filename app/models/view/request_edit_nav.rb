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


  def delete_link
    helpers.link_to(helpers.raw("<i class=\"icon-remove\"></i> Delete Reserve"),
                    routes.course_reserve_path(@reserve.course.id, @reserve.id, redirect_to: 'admin'),
                    data: { confirm: 'Are you sure you wish to remove this reserve from this semester?' },
                    :method => :delete,
                    class: 'btn text-error',
                    :id => "delete_reserve_#{@reserve.id}")

  end


  def meta_data_notes
    policy = ReserveMetaDataPolicy.new(@reserve)
    uls = []
    if @reserve.nd_meta_data_id.present?
      uls << "Record ID: #{@reserve.nd_meta_data_id}"
      uls << "Syncronized on #{@reserve.metadata_synchronization_date.to_s(:long)}"

    elsif policy.meta_data_id_required? && !policy.complete?
      uls << "Requires: Record ID"
    else
      if policy.complete?
        uls << "Meta Data Manually Entered"
      else
        uls << "Requires Meta Data Review"
      end
    end

    return uls
  end


  def electronic_resource_notes
    uls = []
    if requires_electronic_resource?
      if electronic_resouce_comeplete?
        uls << ElectronicReservePolicy.new(@reserve).electronic_resource_type
      else
        uls << "Requires an Electroinc Resource"
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


end

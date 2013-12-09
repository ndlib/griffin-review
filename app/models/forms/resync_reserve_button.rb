
class ResyncReserveButton
  include RailsHelpers

  attr_accessor :reserve

  def self.build_from_params(controller)
    reserve = ReserveSearch.new.get(controller.params[:id])
    self.new(reserve)
  end


  def initialize(reserve)
    @reserve = reserve
  end


  def can_be_resynced?
    @reserve.nd_meta_data_id.present? && @reserve.metadata_synchronization_date.present?
  end


  def button
    if can_be_resynced?
      helpers.link_to("Re-sync Meta Data", routes.resync_path(id: @reserve.id), class: "btn", method: 'put', confirm: (@reserve.overwrite_nd_meta_data ? 'The meta data has been manually edited clicking "ok" will overwrite those changes.' : false))
    else
      ""
    end
  end


  def resync!
    ReserveSynchronizeMetaData.new(@reserve).synchronize!
  end

end

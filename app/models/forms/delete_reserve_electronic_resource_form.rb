

class DeleteReserveElectronicResourceForm
  include RailsHelpers

  attr_accessor :reserve

  def initialize(reserve)
    @reserve = reserve
  end


  def delete_link
    helpers.link_to(helpers.raw("<i class=\"icon-remove\"></i> Delete Electronic Resource"),
                    routes.resource_path(@reserve.id),
                    data: { confirm: 'Clicking "ok" will permamently remove any associated urls and uploaded files. Are you sure you wish to continue?' },
                    :method => :delete,
                    class: 'btn btn-danger',
                    :id => "delete_reserve_#{@reserve.id}")
  end


  def remove!
    @reserve.url = nil
    @reserve.pdf.clear
    @reserve.media_playlist.destroy if @reserve.media_playlist.present?


    @reserve.save!

    ReserveCheckIsComplete.new(@reserve).check!
    true
  end
end

class LibraryReserveForm
  include Virtus.model
  include VirtusFormHelpers
  include ModelErrorTrapping
  include RailsHelpers

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :library, String

  attr_accessor :reserve

  def self.build_from_params(controller)
    reserve = ReserveSearch.new.get(controller.params[:id])
    self.new(reserve, controller.params[:library_reserve_form])
  end

  def initialize(reserve, update_params)
    @reserve = reserve

    set_attributes_from_model(@reserve)
    set_attributes_from_params(update_params)
  end

  def update_reserve_library!(*additions)
    if valid?
      persist!(additions[0])
      true
    else
      return false
    end
  end

  private

  def persist!(*additions)
    if self.attributes.key?(:library) && additions.present?
      value = self.attributes.fetch(:library, 'unknown')
      Message.create({'creator'=>additions[0],
        'content'=>"Fulfillment Library changed from #{@reserve.library} to #{value}.",
        'request_id'=>@reserve.id})
    end
    @reserve.attributes = self.attributes
    @reserve.save!

    ReserveCheckIsComplete.new(@reserve).check!
  end

end

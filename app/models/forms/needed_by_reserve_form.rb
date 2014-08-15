class NeededByReserveForm
  include Virtus
  include VirtusFormHelpers
  include ModelErrorTrapping
  include RailsHelpers

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  attribute :needed_by, String

  attr_accessor :reserve

  def self.build_from_params(controller)
    reserve = ReserveSearch.new.get(controller.params[:id])
    self.new(reserve, controller.params[:needed_by_reserve_form])
  end
  
  def initialize(reserve, update_params)
    @reserve = reserve

    set_attributes_from_model(@reserve)
    set_attributes_from_params(update_params)
  end
  
  def update_reserve_needed_by!
    if valid?
      persist!
      true
    else
      return false
    end
  end

  private

  def persist!
    @reserve.attributes = self.attributes
    @reserve.save!

    ReserveCheckIsComplete.new(@reserve).check!
  end

end

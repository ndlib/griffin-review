
class PhysicalElectronicReserveForm
  include Virtus
  include VirtusFormHelpers
  include ModelErrorTrapping
  include RailsHelpers

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :physical_reserve, Boolean
  attribute :electronic_reserve, Boolean

  validates_with ValidatePhysicalElectronic

  attr_accessor :reserve

  def self.build_from_params(controller)
    reserve = ReserveSearch.new.get(controller.params[:id])
    self.new(reserve, controller.params[:physical_electronic_reserve_form])
  end


  def initialize(reserve, update_params)
    @reserve = reserve

    set_attributes_from_model(@reserve)
    set_attributes_from_params(update_params)
  end


  def link_to_form
    helpers.link_to description_of_reserve_type, routes.edit_type_path(@reserve.id)
  end


  def description_of_reserve_type
    if both_physical_and_electronic?
      "Physical and Electronic Reserve"
    elsif electronic_reserve?
      "Electronic Reserve"
    elsif physical_reserve?
      "Physical Reserve"
    else
      raise "invalid reserve type"
    end
  end


  def physical_reserve?
    @physical_reserve ||= PhysicalReservePolicy.new(@reserve).is_physical_reserve?
  end


  def electronic_reserve?
    @electronic_reserve ||= ElectronicReservePolicy.new(@reserve).is_electronic_reserve?
  end


  def both_physical_and_electronic?
    physical_reserve? && electronic_reserve?
  end


  def update_reserve_type!
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

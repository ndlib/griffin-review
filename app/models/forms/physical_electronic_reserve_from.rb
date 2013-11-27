
class PhysicalElectronicReserveForm
  include Virtus
  include ModelErrorTrapping

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :physical_reserve, Boolean
  attribute :electronic_reserve, Boolean


  def initialize(controller)
    @controller = controller

    self.attributes.each_key do |key|
      self.send("#{key}=", @reserve.send(key))
    end

    if controller.params[:physical_electronic_reserve_form]
      self.attributes = controller.params[:physical_electronic_reserve_form]
    end
  end


  def update_reserve_type!

  end


  private

    def persist!

    end


end

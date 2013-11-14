class ReserveTypeForm
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve

  attribute :nd_meta_data_id, String
  attribute :overwrite_nd_meta_data, Boolean
  attribute :physical_reserve, Boolean
  attribute :electronic_reserve, Boolean


  def initialize(controller)
    @controller = controller

    self.attributes.each_key do |key|
      self.send("#{key}=", @reserve.send(key))
    end

    if @controller.params[:form_fields]

    end
  end


  def resync?

  end


  def can_resync?

  end


  def finished?

  end


  def set_reserve_type
    if valid?
      persist!
      return true
    else
      return false
    end
  end


  private

    def persist!

    end

end

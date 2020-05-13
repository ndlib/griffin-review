class WorkflowStateForm
  include Virtus.model
  include VirtusFormHelpers
  include ModelErrorTrapping
  include RailsHelpers

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :workflow_state, String

  attr_accessor :reserve

  def self.build_from_params(controller)
    reserve = ReserveSearch.new.get(controller.params[:id])
    self.new(reserve, controller.params[:workflow_state_form])
  end

  def initialize(reserve, update_params)
    @reserve = reserve

    set_attributes_from_model(@reserve)
    set_attributes_from_params(update_params)
  end

  def update_workflow_state!(*additions)
    state = self.attributes.fetch(:workflow_state, 'unknown')
    @reserve.on_order = false
    if state == "on_order"
      @reserve.on_order = true
    end

    if valid?
      persist!(additions[0])
      true
    else
      return false
    end
  end

  private

  def persist!(*additions)
    if additions.present?
      value = self.attributes.fetch(:workflow_state, 'unknown')
      Message.create({'creator'=>additions[0],
        'content'=>"State changed from #{@reserve.workflow_state} to #{value}.",
        'request_id'=>@reserve.id})
    end
    @reserve.attributes = self.attributes
    @reserve.save!

    ReserveCheckIsComplete.new(@reserve).check!
  end

end

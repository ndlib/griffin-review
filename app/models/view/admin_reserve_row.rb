class AdminReserveRow

  attr_accessor :reserve

  delegate :id, :title, :workflow_state, to: :reserve


  def initialize(reserve)
    @reserve = reserve
  end


  def request_date
    @reserve.created_at.to_date.to_s(:short)
  end


  def button
    @button ||= AdminEditButton.new(@reserve)
  end


  def requestor
    @reserve.requestor_name
  end


  def needed_by
    if !@reserve.needed_by.nil?
      @reserve.needed_by.to_date.to_s(:short)
    else
      "Not Entered"
    end
  end


  def request_date
    @reserve.created_at.to_date.to_s(:short)
  end


  def course_title
    reserve.course.title
  end


  def type
    reserve.type.gsub('Reserve', '')
  end


  def missing_data
    ret = [self.workflow_state]
    ret << 'fair_use' if !fair_use_policy.complete?
    ret << 'meta_data' if !meta_data_policy.complete?
    ret << 'resource' if !external_resource_policy.complete?
    ret << 'on_order' if !awaiting_purchase_policy.complete?

    ret.join(' ')
  end


  private

    def fair_use_policy
      @fair_use_policy ||= ReserveFairUsePolicy.new(@reserve)
    end


    def meta_data_policy
      @meta_data_policy ||= ReserveMetaDataPolicy.new(@reserve)
    end


    def external_resource_policy
      @external_resource_policy ||= ReserveResourcePolicy.new(@reserve)
    end


    def awaiting_purchase_policy
      @external_resource_policy ||= ReserveAwaitingPurchasePolicy.new(@reserve)
    end
end

class AdminReserveListing

  attr_accessor :reserve

  delegate :id, :title, :type, :workflow_state, to: :reserve


  def initialize(reserve)
    @reserve = reserve
  end


  def button
    @button ||= AdminEditButton.new(@reserve)
  end


  def requestor
    @reserve.requestor_name
  end


  def needed_by
    @reserve.needed_by.to_date.to_s(:short)
  end


  def request_date
    @reserve.created_at.to_date.to_s(:short)
  end


  def fair_use_display

    if fair_use_policy.requires_fair_use?
      if fair_use_policy.fair_use_complete?
        return "<span class=\"complete_text\">Yes</span>"
      else
        return "<span class=\"missing_text\">Not Done</span>"
      end
    else
      return "<span class=\"complete_text\">Not Required</span>"
    end
  end


  private

    def fair_use_policy
      @fair_use_policy = ReserveFairUsePolicy.new(@reserve)
    end
end

class AdminReserveRow

  attr_accessor :reserve

  delegate :id, :workflow_state, to: :reserve


  def initialize(reserve, context)
    @reserve = reserve
    @context = context
  end


  def request_date
    @reserve.created_at.to_date.to_s(:short)
  end


  def button
    @button ||= AdminEditButton.new(@reserve)
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


  def title
    @context.link_to(reserve.title, @context.request_path(reserve.id) )
  end


  def course_col
    @context.link_to(reserve.course.full_title.truncate(40), @context.course_reserves_path(reserve.course.id), target: '_blank' )
  end


  def requestor_col
    @context.link_to(@reserve.requestor_name, @context.new_masquerades_path(:username => @reserve.requestor_netid))
  end


  def type
    reserve.type.gsub('Reserve', '')
  end


  def subtitles
    ret = ""
    if @reserve.language_track.present?
      ret += "Language: #{@reserve.language_track} <br>"
    end

    if @reserve.subtitle_language.present?
      ret += "Subtitle: #{@reserve.subtitle_language}"
    end

    @context.raw(ret)
  end


  def missing_data
    ret = [self.workflow_state]

    if self.workflow_state != 'new'
      ret << 'fair_use' if !fair_use_policy.complete?
      ret << 'meta_data' if !meta_data_policy.complete?
      ret << 'resource' if !external_resource_policy.complete?
      ret << 'on_order' if !awaiting_purchase_policy.complete?
      ""
    end

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
      @awaiting_purchase_policy ||= ReserveAwaitingPurchasePolicy.new(@reserve)
    end
end

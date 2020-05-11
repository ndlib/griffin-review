class RequestRow
  include RailsHelpers

  attr_reader :reserve

  delegate :id, :workflow_state, to: :reserve

  def initialize(reserve)
    @reserve = reserve
  end

  def request_date
    reserve.created_at.to_date.to_s(:short)
  end


  def button
    @button ||= AdminEditButton.new(reserve)
  end


  def needed_by
    if !reserve.needed_by.nil?
      reserve.needed_by.to_date.to_s(:short)
    else
      "Not Entered"
    end
  end


  def needed_by_json
    if !reserve.needed_by.nil?
      reserve.needed_by.to_time.to_i
    else
      9999999999
    end
  end


  def request_date
    reserve.created_at.to_date.to_s(:short)
  end

  def request_date_timestamp
    reserve.created_at.to_i
  end

  def title
    if reserve.item_selection_title.present?
      helpers.raw "#{helpers.link_to reserve.item_selection_title, routes.request_path(reserve.id), target: '_blank'}<br>#{reserve.item_title}"
    else
      helpers.link_to reserve.item_title, routes.request_path(reserve.id), target: '_blank'
    end
  end

  def sortable_title
    reserve.sortable_title
  end

  def course_col
    helpers.link_to(reserve.course.full_title.truncate(40), routes.course_reserves_path(reserve.course.id), target: '_blank' )
  end


  def requestor_col
    helpers.link_to(reserve.requestor_name, routes.new_masquerades_path(:username => reserve.requestor_netid))
  end


  def instructor_col
    instructor = reserve.course.primary_instructor
    helpers.link_to("#{instructor.last_name}, #{instructor.first_name}", routes.new_masquerades_path(:username => instructor.username))
  end

  def type_display
    type.gsub('Reserve', '')
  end

  def type
    reserve.item_type.to_s
  end


  def cache_key
    "admin-reserve-v1-#{reserve.id}-#{reserve.updated_at.to_i}"
  end

  def not_in_aleph?
    workflow_state != 'removed' && reserve.item_physical_reserve? && !reserve.currently_in_aleph?
  end

  def search_keywords
    keywords = []
    if reserve.item_electronic_reserve?
      keywords << 'electronic'
    end
    if reserve.item_physical_reserve?
      keywords << 'physical'
    end

    keywords.join(' ')
  end

  def request_statuses
    statuses = []
    if workflow_state == 'inprocess'
      if reserve.item_on_order?
        statuses << 'on_order'
      else
        statuses << 'inprocess'
      end
    else
      statuses << workflow_state
    end
    if not_in_aleph?
      statuses << 'not_in_aleph'
    end
    statuses.join(' ')
  end

  def library
    reserve.library
  end

  def progress
    if ReserveMetaDataPolicy.new(@reserve).complete?
      rmdp_bg = 'status-complete'
    else
      rmdp_bg ='status-todo'
    end
    if ElectronicReservePolicy.new(@reserve).is_electronic_reserve?
      if ElectronicReservePolicy.new(@reserve).has_resource?
        erp_bg = 'status-complete'
        if @reserve.fair_use.complete?
          rfup_bg = 'status-complete'
        else
          rfup_bg = 'status-todo'
        end
      else
        erp_bg = 'status-todo'
        rfup_bg = 'status-todo'
      end
    else
      erp_bg = 'status-na'
      rfup_bg = 'status-na'
    end
    "<div style='width: 100%'>
      <div class='status-left #{rmdp_bg}'>&nbsp;</div>
      <div class='status-middle #{erp_bg}'>&nbsp;</div>
      <div class='status-right #{rfup_bg}'>&nbsp;</div>
      <br style='clear: left;' />
    </div>"
  end

  def cached_json
    # puts "Item to_json - #{cache_key}"
    Rails.cache.fetch(cache_key) do
      # puts "MISS on #{cache_key}"
      to_json
    end
  end

  def to_json
    [needed_by, progress, title, request_date, instructor_col, course_col, type_display,  request_date_timestamp, needed_by_json, search_keywords, request_statuses, library, type, sortable_title]
  end

end

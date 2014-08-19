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


  def title
    if reserve.selection_title.present?
      helpers.raw "#{helpers.link_to reserve.selection_title, routes.request_path(reserve.id), target: '_blank'}<br>#{reserve.title}"
    else
      helpers.link_to reserve.title, routes.request_path(reserve.id), target: '_blank'
    end
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

  def type
    reserve.type.gsub('Reserve', '')
  end


  def cache_key
    "admin-reserve-#{reserve.id}-#{reserve.updated_at.to_s.gsub(' ', '-').gsub('/', '-')}#{reserve.item.updated_at.to_s.gsub(' ', '-').gsub('/', '-')}"
  end


  def search_keywords
    txt = ""
    if reserve.electronic_reserve?
      txt += 'electronic'
    end
    if reserve.physical_reserve?
      txt += ' physical'
    end

    txt
  end

  def cached_json
    # puts "Item to_json - #{cache_key}"
    Rails.cache.fetch(cache_key) do
      # puts "MISS on #{cache_key}"
      to_json
    end
  end

  def to_json
    [needed_by, title, request_date, requestor_col, course_col, type,  reserve.created_at.to_time.to_i, needed_by_json, search_keywords]
  end

end

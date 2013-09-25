class SakaiIntegrator

  attr_reader :session_id
  attr_accessor :site_id, :sakai_user

  def initialize(controller)
    @controller = controller
    @session_id = soap_auth
    @client = soap_client
  end


  def get_site_property(property_name)
    session_id = @session_id
    site_id = @site_id
    response = @client.call(:get_site_property) do
      message sessionid: session_id, site_id: site_id, propname: property_name
    end
    response.body[:get_site_property_response][:get_site_property_return]
  end


  def translate_external_site_id(external_site_id)
    (search_type, search_value, search_term) = parse_external_site_id(external_site_id)
    section_group = nil
    course_search = CourseSearch.new
    course_search.all_courses(@sakai_user, search_term).each do |course|
      return_value = find_section_group(course, search_type, search_value)
      section_group = return_value if !return_value.blank?
    end
    return [section_group, search_term]
  end

  private


  def soap_client
    Savon.client(log: false, open_timeout: 10, read_timeout: 10, wsdl: Rails.configuration.sakai_script_wsdl)
  end


  def soap_auth
    client = Savon.client(log: false, open_timeout: 10, read_timeout: 10, wsdl: Rails.configuration.sakai_login_wsdl)
    response = client.call(:login) do
      message id: ENV["SAKAI_ADMIN_USERNAME"], pw: ENV["SAKAI_ADMIN_PASSWORD"]
    end

    return response.body[:login_response][:login_return]
  end


  def parse_external_site_id(external_site_id)
    type, value, term = nil
    if external_site_id =~ /^XLS/
      type = 'crosslist'
      parts_array = /^(XLS)(.+)(\d{6})$/.match(external_site_id).captures
      term = parts_array[2]
      value = parts_array[2]
      parts_array[1].scan(/.{2}/).each do |xls_id|
        value = value + '_' + xls_id
      end
    elsif external_site_id =~ /.+-SS/
      type = 'supersection'
      parts_array = /^(\w{2})(\d{2})-(\w+)-(\d+)-(\w+)/.match(external_site_id).captures
      (term, year_value) = calculate_term(parts_array)
      value = external_site_id
    else
      type = 'section'
      puts "EX: " + external_site_id
      parts_array = /^(\w{2})(\d{2})-(\w+)-(\d+)-(\d+)/.match(external_site_id).captures
      (term, year_value) = calculate_term(parts_array)
      value = year_value + term_alpha_to_num(parts_array[0]) + '_' + parts_array[2] + '_' + parts_array[3] + '_' + parts_array[4]
    end
    return [type, value, term]
  end


  def find_section_group(course, search_type, search_value)
    case search_type
    when 'crosslist'
      section_group_by_crosslist(course, search_value)
    when 'supersection'
      section_group_by_supersection(course, search_value)
    when 'section'
      section_group_by_section(course, search_value)
    end
  end


  def section_group_by_crosslist(course, search_value)
    if course.id == search_value
      course.id
    end
  end


  def section_group_by_supersection(course, search_value)
    if course.unique_supersection_ids.include?(search_value)
      course.id
    end
  end


  def section_group_by_section(course, search_value)
    id = nil
    course.sections.each do |section|
      section_number = "%02d" % section.section_number
      section_triple_number = section.triple + '_' + section_number
      if section_triple_number == search_value
        id = course.id
      end
    end
    return id
  end


  def get_parts_array(pattern, external_site_id)
    /"#{pattern}"/.match(external_site_id).captures
  end


  def calculate_term(parts_array)
      year_value = calculate_year(parts_array)
      term = year_value + term_alpha_to_num(parts_array[0])
      return [term, year_value]
  end


  def calculate_year(parts_array)
    year_value = 2000 + parts_array[1].to_i
    year_value = year_value - 1 if parts_array[0] == 'SP'
    return year_value.to_s
  end


  def term_alpha_to_num(alpha)
    case alpha
    when 'SU'
      '00'
    when 'FA'
      '10'
    when 'SP'
      '20'
    end
  end


end

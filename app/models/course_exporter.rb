require 'csv'

# for exporting course reserves data into a CSV file format
class CourseExporter
  attr_accessor :courses

  def initialize(course_id)
    @course = CourseSearch.new.get(course_id)
    @physical_reserves = {}
  end

  def course_content
    reserves.each do | r |
      if PhysicalReservePolicy.new(r).is_physical_reserve?
        add_reserve(r)
      end
    end
    generate_csv
  end

  def reserves
    ReserveSearch.new.student_reserves_for_course(@course)
  end

  def add_reserve(reserve)
    da = DiscoveryApi.search_by_ids(reserve.id.to_s).first
    @physical_reserves[reserve.id] ||= {
      available_library: da.available_library,
      availability: da.availability,
      type: da.type,
      id: da.id,
      title: da.title,
      creator_contributor: da.creator_contributor,
      barcode: da.barcode
    }
  end

  def generate_csv
    CSV.generate do |csv|
      csv << output_fields
      @physical_reserves.each do | key, value |
        csv << [
          value[:available_library], value[:availability], value[:type], value[:id],
          value[:title], value[:creator_contributor], value[:barcode]
        ]
      end
    end
  end

  def output_fields
    %w(
      available_library availability type id title creator_contributor barcode
    )
  end
end

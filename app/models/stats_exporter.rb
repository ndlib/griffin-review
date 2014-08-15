require 'csv'

# for exporting reserves data into a CSV file format
class StatsExporter
  attr_accessor :courses

  def initialize(semester_id = Semester.current.last.id)
    @semester = Semester.find(semester_id)
    @courses = {}
  end

  def stats_content
    reserves.each do | r |
      next if r.removed?
      add_course(r)
      add_reading(r)
    end
    generate_csv
  end

  def reserves
    ReserveSearch.new.reserves_for_semester(@semester)
  end

  def add_course(reserve)
    @courses[reserve.course_id] ||= {
      title: reserve.course.title,
      primary_instructor: reserve.course.primary_instructor_hash['full_name'],
      course_code: reserve.course.crosslisted_course_ids.first,
      uploaded_readings: 0,
      url_readings: 0,
      videos: 0,
      sipx: 0,
      physical_reserves: 0
    }
  end

  def add_reading(r)
    erp = ElectronicReservePolicy.new(r)
    if PhysicalReservePolicy.new(r).is_physical_reserve?
      increment_stat(r, :physical_reserves)
    elsif erp.electronic_resource_type == 'File'
      increment_stat(r, :uploaded_readings)
    elsif erp.electronic_resource_type == 'Streaming Video'
      increment_stat(r, :videos)
    elsif erp.electronic_resource_type == 'Website Redirect'
      increment_stat(r, :url_readings)
    elsif erp.electronic_resource_type == 'SIPX'
      increment_stat(r, :sipx)
    else
      @unacconted_readers ||= []
      @unacconted_readers << r
    end
  end

  def increment_stat(r, stat)
    @courses[r.course_id][stat] += 1
  end

  def generate_csv
    CSV.generate do |csv|
      csv << output_fields
      @courses.each do | key, value |
        csv << [
          key, value[:title], value[:primary_instructor], value[:course_code],
          value[:uploaded_readings], value[:url_readings], value[:videos],
          value[:sipx], value[:physical_reserves]
        ]
      end
    end
  end

  def output_fields
    %w(
      id title instructor course_code uploaded_readings
      url_readings videos sipx physical_reserves
    )
  end
end

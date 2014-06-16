require 'csv'

class StatsExporter

  attr_accessor :courses

  def self.export!
    self.new.export!
  end


  def initialize
    @semester = Semester.current.first
    @courses = {}
    @current_user = User.where(:username => 'jhartzle').first
  end


  def export!
    reserves.each do | r |
      if r.removed?
        next
      end
      add_course(r)
      add_reading(r)
    end

    write_output!
  end


  def reserves
    ReserveSearch.new.reserves_for_semester(@semester)
  end

  def add_course(reserve)
    puts reserve.id

    header = CourseHeader.new(reserve.course, @current_user)
    @courses[reserve.course_id] ||= {
      primary_instructor: header.instructor_name,
      course_code: header.instructor_name,
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


  def write_output!
    CSV.open(Rails.root.join('stats', "#{@semester.code}.csv"), "wb") do |csv|
      csv << ['id', 'instructor', 'course_code', 'uploaded_readings', 'url_readings', 'videos', 'sipx', 'physical_reserves']
      @courses.each do | key, value |
        csv << [key, value[:primary_instructor], value[:course_code], value[:uploaded_readings], value[:url_readings], value[:videos], value[:sipx], value[:physical_reserves]]
      end
    end

  end
end

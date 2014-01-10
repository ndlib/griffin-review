class BookReserveImport

  attr_accessor :api_data, :errors


  def initialize(api_data)
    @api_data = api_data
    @errors = []

    validate!
  end


  def import!
    if can_import?
      reserve.title = bib_title

      reserve.nd_meta_data_id = bib_id
      reserve.realtime_availability_id = realtime_availability_id
      reserve.course = course
      if reserve.physical_reserve.nil?
        reserve.physical_reserve = true
      end

      if reserve.requestor_netid.nil?
        reserve.requestor_netid = 'import'
      end

      if !reserve.nd_meta_data_id.nil?
        reserve.overwrite_nd_meta_data = false
      end

      reserve.type = format_to_type[format]
      if reserve.type.nil?
        add_error("format of #{format} not found in the list of traped formats")
        return false
      end

      if reserve.type == 'VideoReserve' && reserve.electronic_reserve.nil?
        reserve.electronic_reserve = true
      end

      begin
        ActiveRecord::Base.transaction do
          reserve.save!

          ReserveSynchronizeMetaData.new(reserve).synchronize!
          ReserveCheckIsComplete.new(reserve).check!
        end
      rescue Exception => e
        add_error(e.message)
      end

    end

    success?
  end


  def new_reserve?
    reserve.request.new_record?
  end


  def reserve
    return @reserve if @reserve

    @reserve ||= ReserveSearch.new.reserve_by_bib_for_course(course, bib_id)
    @reserve ||= ReserveSearch.new.reserve_by_rta_id_for_course(course, realtime_availability_id)
    @reserve ||= Reserve.new
  end


  def success?
    @errors.empty?
  end


  def course
    @course ||= CourseSearch.new.get(course_id)
  end


  def bib_id
    "ndu_aleph#{@api_data['bib_id']}"
  end


  def realtime_availability_id
    @api_data['doc_number']
  end


  def course_id
    @api_data['crosslist_id']
  end


  def bib_title
    @api_data['title']
  end


  def format
    puts @api_data.inspect
    @api_data['format'].downcase
  end


  def format_to_type
    {
      'book' => 'BookReserve',
      'bound serial' => 'BookReserve',
      'serial (unbound issue)' => 'BookReserve',
      'dvd (visual)' => 'VideoReserve',
      'video cassette (visual)' => 'VideoReserve'
    }
  end

  private

    def add_error(msg)
      @errors << msg
    end


    def validate!
      if course.nil?
        add_error("Unable to find course #{course_id}")
      end
    end


    def can_import?
      course.present?
    end

end

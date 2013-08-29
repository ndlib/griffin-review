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
      reserve.type = "BookReserve"
      reserve.nd_meta_data_id = bib_id
      reserve.course = course
      # this needs to happen so that ReserveCheckIsComplete will make the reserve available.
      # because we don't want that class to complete new items normally
      reserve.start

      if reserve.requestor_netid.nil?
        reserve.requestor_netid = 'import'
      end

      begin
        ActiveRecord::Base.transaction do
          reserve.save!

          ReserveSynchronizeMetaData.new(reserve).check_synchronized!
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
    @reserve ||= ReserveSearch.new.reserve_by_bib_for_course(course, bib_id) || Reserve.new
  end


  def success?
    @errors.empty?
  end


  def course
    @course ||= CourseSearch.new.get(course_id)
  end


  def bib_id
    @api_data['bib_id']
  end


  def course_id
    @api_data['crosslist_id']
  end


  def bib_title
    @api_data['title']
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
      course.present? && new_reserve?
    end

end

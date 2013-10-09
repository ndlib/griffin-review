class InstructorReserveRequest
  include Virtus
  include ModelErrorTrapping
  include GetCourse

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :course, :current_user

  attribute :title, String
  attribute :publisher, String
  attribute :journal_title, String
  attribute :language_track, String
  attribute :subtitle_language, String
  attribute :creator, String
  attribute :citation, String
  attribute :length, String
  attribute :note, String
  attribute :needed_by, DateTime
  attribute :requestor_owns_a_copy, Boolean
  attribute :requestor_has_an_electronic_copy, Boolean
  attribute :physical_reserve, Boolean
  attribute :library, String
  attribute :number_of_copies, Integer
  attribute :type, String
  attribute :pdf, String

  validates :title, :needed_by, :library, :presence => true
  validates :creator, :presence => true, :if => :creator_required?
  validates :length, :presence =>  true, :if => :length_required?
  validates :journal_title, :presence =>  true, :if => :journal_title_required?
  validates :citation, :presence => true, :if => :citation_required?
  validates :type, :inclusion => { :in => %w(BookReserve BookChapterReserve JournalReserve AudioReserve VideoReserve) }
  validates :needed_by, :timeliness => { :on_or_after => lambda { Date.current + 2.weeks } }


  def initialize(current_user, params)
    @current_user = current_user
    @course = get_course(params[:course_id])

    self.attributes = params[:instructor_reserve_request] || {}

    validate_inputs!
  end


  def persisted?
    false
  end


  def make_request
    if valid?
      persist!
      notify!
      true
    else
      false
    end
  end


  def creator_required?
    [].include?(type)
  end


  def length_required?
    ['BookChapterReserve'].include?(type)
  end


  def citation_required?
    ['BookReserve', 'BookChapterReserve', 'JournalReserve'].include?(type)
  end


  def journal_title_required?
    [].include?(type)
  end


  def reserve
    @reserve ||= Reserve.new
  end


  def book_request?
    type == 'BookReserve'
  end


  def book_chapter_request?
    type == 'BookChapterReserve'
  end


  def article_request?
    type == 'JournalReserve'
  end


  def video_request?
    type == 'VideoReserve'
  end


  def audio_request?
    type == 'AudioReserve'
  end


  def course_can_create_new_reserve?
    CreateNewReservesPolicy.new(course).can_create_new_reserves?
  end


  def course_title
    "#{@course.title} - #{@course.semester_name}"
  end


  def sections
    @course.section_numbers.join(", ")
  end


  private

    def reserve_class
      if type.nil?
        Reserve
      else
        type.constantize
      end
    end


    def persist!
      reserve.attributes = self.attributes

      reserve.requestor_netid = @current_user.username
      reserve.course          = @course

      reserve.save!
    end


    def validate_inputs!
      if @course.nil? || !course_can_create_new_reserve?
        raise_404
      end

      self.title = self.title.to_s.truncate(250).strip
      self.creator = self.creator.to_s.truncate(250).strip
      self.journal_title = self.journal_title.to_s.truncate(250).strip
    end


    def notify!
      ReserveMailer.new_request_notifier(reserve).deliver
    end

end

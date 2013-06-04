class InstructorReserveRequest
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :course, :current_user

  attribute :title, String
  attribute :publisher, String
  attribute :journal_title, String
  attribute :creator, String
  attribute :length, String
  attribute :note, String
  attribute :needed_by, DateTime
  attribute :requestor_owns_a_copy, Boolean
  attribute :requestor_has_an_electronic_copy, Boolean
  attribute :library, String
  attribute :number_of_copies, Integer
  attribute :type, String

  validates :title, :needed_by, :library, :presence => true
  validates :creator, :presence => true, :if => :creator_required?
  validates :length, :presence =>  true, :if => :length_required?
  validates :journal_title, :presence =>  true, :if => :journal_title_required?
  validates :type, :inclusion => { :in => %w(BookReserve BookChapterReserve JournalReserve AudioReserve VideoReserve) }
  validates :needed_by, :timeliness => { :on_or_after => lambda { Date.current } }

  def initialize(current_user, course, request_attributes = {})
    @current_user = current_user
    @course = course
    self.attributes = request_attributes
  end


  def persisted?
    false
  end


  def make_request
    if valid?
      persist!
      true
    else
      false
    end
  end


  def creator_required?
    ['BookReserve', 'BookChapterReserve', 'JournalReserve', 'AudioReserve'].include?(type)
  end


  def length_required?
    ['BookChapterReserve'].include?(type)
  end


  def journal_title_required?
    ['JournalReserve'].include?(type)
  end


  def reserve
    @reserve ||= reserve_class.new
  end


  def book_request?
    type == 'BookReserve'
  end


  def book_chapter_request?
    type == 'BookChapterReserve'
  end


  def article_request?
    type == 'ArticleReserve'
  end


  def video_request?
    type == 'VideoReserve'
  end


  def audio_request?
    type == 'AudioReserve'
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
      reserve.course = @course
      reserve.semester = @course.semester

      reserve.save!
    end


end

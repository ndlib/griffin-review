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
  attribute :request_type, String
  attribute :type, String

  validates :title, :needed_by, :library, :presence => true
  validates :creator, :presence => true, :if => :creator_required?
  validates :length, :presence =>  true, :if => :length_required?
  validates :journal_title, :presence =>  true, :if => :journal_title_required?


  def initialize(current_user, course)
    @current_user = current_user
    @course = course
  end


  def persisted?
    false
  end


  def save
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


  private

    def persist!

    end


end

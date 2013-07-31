class Reserve
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks

  delegate :metadata_synchronization_date, :on_order, :details, :type, :publisher, :title, :journal_title, :creator, :length, :url, :nd_meta_data_id, :overwrite_nd_meta_data, :overwrite_nd_meta_data?, to: :item
  delegate :metadata_synchronization_date=, :on_order=, :details=, :type=, :publisher=, :title=, :journal_title=, :creator=, :length=, :pdf, :pdf=, :url=, :nd_meta_data_id=, :overwrite_nd_meta_data=, :overwrite_nd_meta_data=, to: :item
  delegate :details, :available_library, :availability, :publisher_provider, :creator_contributor, to: :item

  delegate :created_at, :id, :semester, :workflow_state, :course_id, :crosslist_id, :requestor_netid, :needed_by, :number_of_copies, :note, :requestor_owns_a_copy, :library, :requestor_netid, to: :request
  delegate :id=, :semester=, :workflow_state=, :course_id=, :requestor_netid=, :needed_by=, :number_of_copies=, :note=, :requestor_owns_a_copy=, :library=, :requestor_netid=, to: :request

  attr_accessor :course, :request
  attr_accessor :requestor_has_an_electronic_copy
  attr_accessor :fair_use, :requestor

  state_machine :workflow_state, :initial => :new do

    event :complete do
      transition [:new, :inprocess] => :available
    end


    event :remove do
      transition [:new, :inprocess, :available] => :removed
    end


    event :start do
      transition [:new] => :inprocess
    end


    event :restart do
      transition [:available] => :inprocess
    end

    state :new
    state :inproess
    state :available
    state :removed
  end


  def self.factory(request, course = nil)
    self.new(request: request, course: course)
  end


  def initialize(attrs = {})
    self.attributes= attrs

    # this is required for the state_machine gem do not forget again and remove
    super()

    if !self.request.new_record?
      ReserveSynchronizeMetaData.new(self).check_synchronized!
    end
  end


  def attributes=(attrs= {})
    attrs.keys.each do  | key |
      self.send("#{key}=", attrs[key])
    end
  end


  def item
    @item ||= (request.item || request.build_item)
  end


  def item_id
    item.id
  end


  def requestor_name
    @user ||= User.where(:username => self.requestor_netid).first
    if !@user
      return ""
    end

    @user.display_name
  end

  def request
    @request ||= Request.new
  end


  def save!
    ActiveRecord::Base.transaction do
      item.save!

      request.item = item
      request.course_id = course.id
      request.crosslist_id = course.crosslist_id
      request.semester_id = course.semester.id

      request.save!

      ReserveCheckIsComplete.new(self).check!
    end
  end


  def destroy!
    if self.remove
      self.save!
    end
  end


  def set_topics!(topics)
    request.topic_list = topics
    save!
  end


  def topics
    request.topics
  end


  def persisted?
    false
  end


  def course
    @course ||= CourseSearch.new.get(self.course_id)
  end


  def fair_use
    @fair_use ||= ( FairUse.request(self).first || FairUse.new(request: request) )
  end



  def self.generate_test_data_for_course(course)
    BookReserve.test_request(course).save!
    BookReserve.new_request(course).save!
    BookReserve.awaiting_request(course).save!

    BookChapterReserve.test_request(course).save!
    BookChapterReserve.new_request(course).save!
    BookChapterReserve.awaiting_request(course).save!

    JournalReserve.test_file_request(course).save!
    JournalReserve.test_url_request(course).save!

    VideoReserve.test_request(course).save!
    VideoReserve.new_request(course).save!
    VideoReserve.awaiting_request(course).save!

    AudioReserve.test_request(course).save!
  end


end



class BookReserve < Reserve

  def self.test_request(course = nil)
    self.new( course: course, type: self.to_s, workflow_state: "available", requestor_netid: "jhartzle", needed_by: 4.days.from_now, title: "Book Request", creator: 'Hartzler, Jon', nd_meta_data_id: "book")
  end


  def self.new_request(course = nil)
    self.new( course: course, type: self.to_s, type: self.to_s, workflow_state: "new", requestor_netid: "jhartzle", needed_by: 2.days.from_now, title: "New Book Request", creator: 'Hartzler, Jon')
  end

  def self.awaiting_request( course = nil)
    self.new( course: course, type: self.to_s, workflow_state: "inprocess", requestor_netid: "rfox2", needed_by: 2.days.from_now, title: "Awaiting Book Request", creator: 'Hartzler, Jon')
  end

end


class BookChapterReserve < Reserve

  def self.test_request( course = nil)
    self.new( course: course, type: self.to_s,  workflow_state: "available", requestor_netid: "jkennel", needed_by: 6.days.from_now, nd_meta_data_id: "funny book", title: "Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7", pdf:  File.open("#{Rails.root}/uploads/test.pdf"))
  end

  def self.new_request( course = nil)
    self.new( course: course, type: self.to_s, workflow_state: "new", requestor_netid: "jhartzle", needed_by: 6.days.from_now, title: "New Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7", pdf: File.open("#{Rails.root}/uploads/test.pdf"))
  end

  def self.awaiting_request( course = nil)
    self.new( course: course, type: self.to_s, workflow_state: "inprocess", nd_meta_data_id: "discovery", requestor_netid: "Jaron Kennel", needed_by: 6.days.from_now, title: "New Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7")
  end

end


class JournalReserve < Reserve

  def self.test_file_request( course = nil)
    self.new( type: self.to_s, workflow_state: "available",  course: course, requestor_netid: "Bob Bobbers", needed_by: 10.days.from_now, title: "Journal File Request", creator: 'Fox, Rob', journal_title: "Journal", length: "pages: 33-44", pdf: File.open("#{Rails.root}/uploads/test.pdf"))
  end


  def self.test_url_request(course = nil)
    self.new( type: self.to_s, workflow_state: "available",  course: course, requestor_netid: "Person", needed_by: 1.days.from_now, title: "Journal Url Request", creator: 'Wetheril, Andy', journal_title: "Journal", length: "pgs: 55-66", url: "http://www.google.com")
  end

end


class VideoReserve < Reserve
  def self.test_request( course = nil)
    self.new( type: self.to_s, workflow_state: "available",  course: course, requestor_netid: "Prof P", needed_by: 4.days.from_now, nd_meta_data_id: "Star wars", title: "Movie", creator: 'Robin Schaaf', length: "42:33 20 min.", url: "HimesKeynote.mov")
  end


  def self.new_request( course = nil)
    self.new( type: self.to_s, workflow_state: "inprocess",  course: course, requestor_netid: "Prof Q", needed_by: 14.days.from_now, nd_meta_data_id: "Empire Strikes Back", title: "Movie", creator: 'Robin Schaaf', length: "42:33 20 min.", url: "HimesKeynote.mov")
  end


  def self.awaiting_request(course = nil)
    self.new( type: self.to_s, workflow_state: "new", course: course, requestor_netid: "Prof 9", needed_by: 8.days.from_now, title: "Return of the Jedi", creator: 'George L', length: "42:33 20 min.")
  end

end


class AudioReserve < Reserve

  def self.test_request(course = nil)
    self.new( type: self.to_s, workflow_state: "available",  course: course, requestor_netid: "bla bla", needed_by: 11.days.from_now, nd_meta_data_id: "kinda blue", title: "Audio", creator: 'Music Person', length: "3:33 15 min.", url: "HimesKeynote.mov")
  end

end


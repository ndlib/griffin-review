class Reserve
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  delegate :type, :publisher, :title, :journal_title, :creator, :length, :file, :url, :nd_meta_data_id, :overwrite_nd_meta_data?, to: :item
  delegate :type=, :publisher=, :title=, :journal_title=, :creator=, :length=, :file=, :url=, :nd_meta_data_id=, :overwrite_nd_meta_data=, to: :item
  delegate :details, :available_library, :availability, :publisher_provider, :creator_contributor, to: :item

  delegate :id, :workflow_state, :course_id, :requestor_netid, :needed_by, :number_of_copies, :note, :requestor_owns_a_copy, :library, :requestor_netid, to: :request
  delegate :id=, :workflow_state=, :course_id=, :requestor_netid=, :needed_by=, :number_of_copies=, :note=, :requestor_owns_a_copy=, :library=, :requestor_netid=, to: :request

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


  def self.factory(request)
    self.new(request)
  end


  def initialize(attrs = {})
    self.attributes= attrs

    # this is required for the state_machine gem do not forget again and remove
    super()
  end


  def attributes=(attrs= {})
    attrs.keys.each do  | key |
      self.send("#{key}=", attrs[key])
    end
  end


  def item
    @item ||= (request.item || request.build_item)
  end


  def request
    @request ||= Request.new
  end


  def save!
    ActiveRecord::Base.transaction do
      item.save!

      request.item = item
      request.course_id = course.reserve_id

      request.save!
    end
  end


  def ensure_state_is_inprogress!
    if self.start
      self.save!
    end
  end


  def tags
    ['topic 1']
  end


  def persisted?
    false
  end


  def approval_required?
    false
  end


  def self.generate_test_data_for_course(course)

  end
end



class BookReserve < Reserve

  def self.test_request(id = 1, course = nil)
    self.new( id: id, course: course, type: self.to_s, workflow_state: "available", requestor_netid: "Bob Bobbers", needed_by: 4.days.from_now, title: "Book Request", creator: 'Hartzler, Jon', nd_meta_data_id: "book")
  end


  def self.new_request(id = 1, course = nil)
    self.new( id: id, course: course, type: self.to_s, type: self.to_s, workflow_state: "new", requestor_netid: "New Requestor", needed_by: 2.days.from_now, title: "New Book Request", creator: 'Hartzler, Jon')
  end

  def self.awaiting_request(id = 1, course = nil)
    self.new( id: id, course: course, type: self.to_s, workflow_state: "inprocess", requestor_netid: "Awaiting Requestor", needed_by: 2.days.from_now, title: "Awaiting Book Request", creator: 'Hartzler, Jon')
  end

end


class BookChapterReserve < Reserve

  def self.test_request(id = 1, course = nil)
    self.new( id: id, course: course, type: self.to_s, fair_use: "ADFADF", workflow_state: "available", requestor_netid: "Jaron Kennel", needed_by: 6.days.from_now, nd_meta_data_id: "funny book", title: "Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7", file: "/uploads/test.pdf")
  end

  def self.new_request(id = 1, course = nil)
    self.new( id: id, course: course, type: self.to_s, workflow_state: "new", requestor_netid: "Jaron Kennel", needed_by: 6.days.from_now, title: "New Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7", file: "/uploads/test.pdf")
  end

  def self.awaiting_request(id = 1, course = nil)
    self.new( id: id, course: course, type: self.to_s, workflow_state: "inprocess", nd_meta_data_id: "discovery", requestor_netid: "Jaron Kennel", needed_by: 6.days.from_now, title: "New Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7")
  end

end


class JournalReserve < Reserve

  def self.test_file_request(id = 1, course = nil)
    self.new( id: id, type: self.to_s, workflow_state: "available", fair_use: "ADFADF", course: course, requestor_netid: "Bob Bobbers", needed_by: 10.days.from_now, title: "Journal File Request", creator: 'Fox, Rob', journal_title: "Journal", length: "pages: 33-44", file: "/uploads/test.pdf")
  end


  def self.test_url_request(id = 1, course = nil)
    self.new( id: id, type: self.to_s, workflow_state: "available", fair_use: "ADFADF", course: course, requestor_netid: "Person", needed_by: 1.days.from_now, title: "Journal Url Request", creator: 'Wetheril, Andy', journal_title: "Journal", length: "pgs: 55-66", url: "http://www.google.com/")
  end

end


class VideoReserve < Reserve
  def self.test_request(id = 1, course = nil)
    self.new( id: id, type: self.to_s, workflow_state: "available", fair_use: "ADFADF", course: course, requestor_netid: "Prof P", needed_by: 4.days.from_now, nd_meta_data_id: "Star wars", title: "Movie", creator: 'Robin Schaaf', length: "42:33 20 min.", url: "http://www.google.com/")
  end


  def self.new_request(id = 1, course = nil)
    self.new( id: id, type: self.to_s, workflow_state: "inprocess", fair_use: "ADFADF", course: course, requestor_netid: "Prof Q", needed_by: 14.days.from_now, nd_meta_data_id: "Empire Strikes Back", title: "Movie", creator: 'Robin Schaaf', length: "42:33 20 min.", url: "http://www.google.com/")
  end


  def self.awaiting_request(id = 1, course = nil)
    self.new( id: id, type: self.to_s, workflow_state: "new", course: course, requestor_netid: "Prof 9", needed_by: 8.days.from_now, title: "Return of the Jedi", creator: 'George L', length: "42:33 20 min.")
  end

end


class AudioReserve < Reserve

  def self.test_request(id = 1, course = nil)
    self.new( id: id, type: self.to_s, workflow_state: "available", fair_use: "ADFADF", course: course, requestor_netid: "bla bla", needed_by: 11.days.from_now, nd_meta_data_id: "kinda blue", title: "Audio", creator: 'Music Person', length: "3:33 15 min.", url: "http://www.google.com/")
  end



end


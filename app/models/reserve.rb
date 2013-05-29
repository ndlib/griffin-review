class Reserve
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  delegate :publisher, :journal_title, :creator, :length, :file, :url, :nd_meta_data_id, :overwrite_nd_meta_data?, to: :item
  delegate :publisher=, :title=, :journal_title=, :creator=, :length=, :file=, :url=, :nd_meta_data_id=, :overwrite_nd_meta_data=, to: :item


  delegate :id, :workflow_state, :course_id, :requestor_netid, :needed_by, :number_of_copies, :note, :requestor_owns_a_copy, :library, :requestor_netid, to: :request
  delegate :id=, :workflow_state=, :course_id=, :requestor_netid=, :needed_by=, :number_of_copies=, :note=, :requestor_owns_a_copy=, :library=, :requestor_netid=, to: :request

  attr_accessor :course
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
    state :inprocess
    state :available
    state :removed
  end


  def ensure_state_is_inprogress!
    if self.start
      self.save!
    end
  end


  def initialize(attrs = {})
    self.attributes= attrs
    super()
  end


  def attributes=(attrs= {})
    attrs.keys.each do  | key |
      self.send("#{key}=", attrs[key])
    end
  end


  def item
    @item ||= Item.new
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


  def approval_required?
    true
  end


  def tags
    []
  end


  def css_class
    "record-book"
  end


  def link_to_get_listing?
    false
  end


  def persisted?
    false
  end


  def title
    use_discovery_api? ? discovery_record.title : item.title
  end


  def creator_contributor
    use_discovery_api? ? discovery_record.creator_contributor : item.creator
  end


  def publisher_provider
    use_discovery_api? ? discovery_record.publisher_provider : item.journal_title
  end


  def details
    use_discovery_api? ? discovery_record.details : ""
  end


  def availability
    use_discovery_api? ? discovery_record.availability : ""
  end


  def available_library
    use_discovery_api? ? discovery_record.available_library : ""
  end


  def is_available?
    (self.availability.strip == 'Available')
  end

  def type
    self.class.to_s.gsub("Reserve", '')
  end

  private

    def use_discovery_api?
      nd_meta_data_id.present?
    end


    def discovery_record
      if use_discovery_api?
        @discovery_record ||= DiscoveryApi.search_by_ids(nd_meta_data_id).first
      end
    end

end



class BookReserve < Reserve

  def self.test_request(id = 1, course = nil)
    self.new( id: id, course: course, workflow_state: "available", requestor_netid: "Bob Bobbers", needed_by: 4.days.from_now, title: "Book Request", creator: 'Hartzler, Jon', nd_meta_data_id: "book")
  end


  def self.new_request(id = 1, course = nil)
    self.new( id: id, course: course, workflow_state: "new", requestor_netid: "New Requestor", needed_by: 2.days.from_now, title: "New Book Request", creator: 'Hartzler, Jon')
  end

  def self.awaiting_request(id = 1, course = nil)
    self.new( id: id, course: course, workflow_state: "awaiting cataloging", requestor_netid: "Awaiting Requestor", needed_by: 2.days.from_now, title: "Awaiting Book Request", creator: 'Hartzler, Jon')
  end

  def approval_required?
    return false
  end


  def tags
    ['topic 1']
  end


  def css_class
    "record-book"
  end

end


class BookChapterReserve < Reserve

  def self.test_request(id = 1, course = nil)
    self.new( id: id, course: course, fair_use: "ADFADF", workflow_state: "available", requestor_netid: "Jaron Kennel", needed_by: 6.days.from_now, nd_meta_data_id: "funny book", title: "Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7", file: "/uploads/test.pdf")
  end

  def self.new_request(id = 1, course = nil)
    self.new( id: id, course: course, workflow_state: "new", requestor_netid: "Jaron Kennel", needed_by: 6.days.from_now, title: "New Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7", file: "/uploads/test.pdf")
  end

  def self.awaiting_request(id = 1, course = nil)
    self.new( id: id, course: course, workflow_state: "awaiting digitization", nd_meta_data_id: "discovery", requestor_netid: "Jaron Kennel", needed_by: 6.days.from_now, title: "New Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7")
  end


  def approval_required?
    return true
  end


  def tags
    ['topic 2']
  end


  def css_class
    "record-book"
  end


  def link_to_get_listing?
    true
  end

end


class JournalReserve < Reserve

  def self.test_file_request(id = 1, course = nil)
    self.new( id: id, workflow_state: "available", fair_use: "ADFADF", course: course, requestor_netid: "Bob Bobbers", needed_by: 10.days.from_now, title: "Journal File Request", creator: 'Fox, Rob', journal_title: "Journal", length: "pages: 33-44", file: "/uploads/test.pdf")
  end


  def self.test_url_request(id = 1, course = nil)
    self.new( id: id, workflow_state: "available", fair_use: "ADFADF", course: course, requestor_netid: "Person", needed_by: 1.days.from_now, title: "Journal Url Request", creator: 'Wetheril, Andy', journal_title: "Journal", length: "pgs: 55-66", url: "http://www.google.com/")
  end

  def approval_required?
    return self.file.present?
  end


  def tags
    ['topic 1', 'topic 2']
  end


  def link_to_get_listing?
    true
  end


  def css_class
    "record-article"
  end

end


class VideoReserve < Reserve
  def self.test_request(id = 1, course = nil)
    self.new( id: id, workflow_state: "available", fair_use: "ADFADF", course: course, requestor_netid: "Prof P", needed_by: 4.days.from_now, nd_meta_data_id: "Star wars", title: "Movie", creator: 'Robin Schaaf', length: "42:33 20 min.", url: "http://www.google.com/")
  end


  def self.new_request(id = 1, course = nil)
    self.new( id: id, workflow_state: "awaiting digitization", fair_use: "ADFADF", course: course, requestor_netid: "Prof Q", needed_by: 14.days.from_now, nd_meta_data_id: "Empire Strikes Back", title: "Movie", creator: 'Robin Schaaf', length: "42:33 20 min.", url: "http://www.google.com/")
  end


  def self.awaiting_request(id = 1, course = nil)
    self.new( id: id, workflow_state: "new", course: course, requestor_netid: "Prof 9", needed_by: 8.days.from_now, title: "Return of the Jedi", creator: 'George L', length: "42:33 20 min.")
  end


  def approval_required?
    return true
  end


  def tags
    ['topic 1']
  end


  def css_class
    "record-video"
  end


  def link_to_get_listing?
    true
  end


end


class AudioReserve < Reserve

  def self.test_request(id = 1, course = nil)
    self.new( id: id, workflow_state: "available", fair_use: "ADFADF", course: course, requestor_netid: "bla bla", needed_by: 11.days.from_now, nd_meta_data_id: "kinda blue", title: "Audio", creator: 'Music Person', length: "3:33 15 min.", url: "http://www.google.com/")
  end


  def approval_required?
    return true
  end


  def tags
    ['topic 2']
  end


  def css_class
    "record-audio"
  end


  def link_to_get_listing?
    true
  end


end


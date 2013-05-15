class Reserve
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  attr_accessor :title, :journal_title, :length, :file, :url, :course, :id, :note, :citation, :comments, :article_details
  attr_accessor :requestor_owns_a_copy, :number_of_copies, :creator, :needed_by, :requestor_has_an_electronic_copy
  attr_accessor :length, :discovery_id, :library, :publisher, :requestor, :status


  def initialize(attrs = {})
    self.attributes= attrs
  end


  def attributes=(attrs= {})
    attrs.keys.each do  | key |
      self.send("#{key}=", attrs[key])
    end
  end


  def list_partial
    'external/request/lists/basic_listing'
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
    use_discovery_api? ? discovery_record.title : @title
  end


  def creator_contributor
    use_discovery_api? ? discovery_record.creator_contributor : @creator
  end


  def publisher_provider
    use_discovery_api? ? discovery_record.publisher_provider : @journal_title
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
      discovery_id.present?
    end


    def discovery_record
      if use_discovery_api?
        @discovery_record ||= DiscoveryApi.search_by_ids(discovery_id).first
      end
    end

end



class BookReserve < Reserve

  def self.test_request(id = 1, course = nil)
    self.new( id: id, course: course, status: "complete", requestor: "Bob Bobbers", needed_by: 4.days.from_now, title: "Book Request", creator: 'Hartzler, Jon', discovery_id: "book")
  end


  def self.new_request(id = 1, course = nil)
    self.new( id: id, course: course, status: "new", requestor: "New Requestor", needed_by: 2.days.from_now, title: "New Book Request", creator: 'Hartzler, Jon')
  end

  def self.awaiting_request(id = 1, course = nil)
    self.new( id: id, course: course, status: "awaiting cataloging", requestor: "Awaiting Requestor", needed_by: 2.days.from_now, title: "Awaiting Book Request", creator: 'Hartzler, Jon')
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
    self.new( id: id, course: course, status: "complete", requestor: "Jaron Kennel", needed_by: 6.days.from_now, discovery_id: "funny book", title: "Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7", file: "/uploads/test.pdf")
  end

  def self.new_request(id = 1, course = nil)
    self.new( id: id, course: course, status: "new", requestor: "Jaron Kennel", needed_by: 6.days.from_now, title: "New Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7", file: "/uploads/test.pdf")
  end

  def self.awaiting_request(id = 1, course = nil)
    self.new( id: id, course: course, status: "awaiting digitization", discovery_id: "discovery", requestor: "Jaron Kennel", needed_by: 6.days.from_now, title: "New Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7")
  end



  def list_partial
    'external/request/lists/book_chapter_listing'
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
    self.new( id: id, status: "complete", course: course, requestor: "Bob Bobbers", needed_by: 10.days.from_now, title: "Journal File Request", creator: 'Fox, Rob', journal_title: "Journal", length: "pages: 33-44", file: "/uploads/test.pdf")
  end


  def self.test_url_request(id = 1, course = nil)
    self.new( id: id, status: "complete", course: course, requestor: "Person", needed_by: 1.days.from_now, title: "Journal Url Request", creator: 'Wetheril, Andy', journal_title: "Journal", length: "pgs: 55-66", url: "http://www.google.com/")
  end


  def list_partial
    'external/request/lists/journal_listing'
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
    self.new( id: id, status: "complete", course: course, requestor: "Prof P", needed_by: 4.days.from_now, discovery_id: "Star wars", title: "Movie", creator: 'Robin Schaaf', length: "42:33 20 min.", url: "http://www.google.com/")
  end


  def self.new_request(id = 1, course = nil)
    self.new( id: id, status: "awaiting digitization", course: course, requestor: "Prof Q", needed_by: 14.days.from_now, discovery_id: "Empire Strikes Back", title: "Movie", creator: 'Robin Schaaf', length: "42:33 20 min.", url: "http://www.google.com/")
  end


  def self.awaiting_request(id = 1, course = nil)
    self.new( id: id, status: "new", course: course, requestor: "Prof 9", needed_by: 8.days.from_now, title: "Return of the Jedi", creator: 'George L', length: "42:33 20 min.")
  end


  def list_partial
    'external/request/lists/video_listing'
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
    self.new( id: id, status: "complete", course: course, requestor: "bla bla", needed_by: 11.days.from_now, discovery_id: "kinda blue", title: "Audio", creator: 'Music Person', length: "3:33 15 min.", url: "http://www.google.com/")
  end


  def list_partial
    'external/request/lists/audio_listing'
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


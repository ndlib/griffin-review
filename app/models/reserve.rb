class Reserve
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  attr_accessor :title, :journal_title, :length, :file, :url, :course, :id, :note, :citation, :comments, :article_details

  #extras to be replaced when the schema is finalized.
  attr_accessor :requestor_owns_a_copy, :number_of_copies, :creator, :needed_by, :requestor_has_an_electronic_copy
  attr_accessor :length, :discovery_id


  def initialize(attributes = {})
    attributes.keys.each do  | key |
      self.send("#{key}=", attributes[key])
    end
  end


  def list_partial
    'external/request/lists/basic_listing'
  end


  def approval_required?
    true
  end


  def citation
    "Citation will go here."
  end


  def tags
    []
  end

  def css_class
    "book-record"
  end


  def link_to_get_listing?
    false
  end


  def status
    'complete'
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

  def self.test_request(id = 1)
    self.new( id: id, course: Course.test_data("User"), title: "Book Request", creator: 'Hartzler, Jon', discovery_id: "book")
  end


  def approval_required?
    return false
  end


  def tags
    ['topic 1']
  end


  def css_class
    "book-record"
  end


  def status
    'new'
  end


end


class BookChapterReserve < Reserve

  def self.test_request(id = 1)
    self.new( id: id, course: Course.test_data("User"), discovery_id: "funny book", title: "Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7", file: "/uploads/test.pdf")
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
    "book-record"
  end


  def link_to_get_listing?
    true
  end


  def status
    'complete'
  end


end


class JournalReserve < Reserve

  def self.test_file_request(id = 1)
    self.new( id: id, course: Course.test_data("User"), title: "Journal File Request", creator: 'Fox, Rob', journal_title: "Journal", length: "pages: 33-44", file: "/uploads/test.pdf")
  end


  def self.test_url_request(id = 1)
    self.new( id: id, course: Course.test_data("User"), title: "Journal Url Request", creator: 'Wetheril, Andy', journal_title: "Journal", length: "pgs: 55-66", url: "http://www.google.com/")
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


  def status
    'awaiting digitization'
  end

end


class VideoReserve < Reserve
  def self.test_request(id = 1)
    self.new( id: id, course: Course.test_data("User"), discovery_id: "Star wars", title: "Movie", creator: 'Robin Schaaf', length: "42:33 20 min.", url: "http://www.google.com/")
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


  def status
    'complete'
  end


end


class AudioReserve < Reserve

  def self.test_request(id = 1)
    self.new( id: id, course: Course.test_data("User"), discovery_id: "kinda blue", title: "Audio", creator: 'Music Person', length: "3:33 15 min.", url: "http://www.google.com/")
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


  def status
    'complete'
  end


end


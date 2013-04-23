class CourseListing
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :title, :creator, :journal_title, :length, :file, :url, :course, :id, :student_comments, :citation, :comments

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
end



class BookListing < CourseListing

  def self.test_request(id = 1)
    self.new( id: id, course: Course.test_data, title: "Book Request", creator: 'Hartzler, Jon')
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


class BookChapterListing < CourseListing

  def self.test_request(id = 1)
    self.new( id: id, course: Course.test_data, title: "Book Chapter Request", creator: 'Kennel, Jaron', length: "Chapter 7", file: "/uploads/test.pdf")
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


class JournalListing < CourseListing

  def self.test_file_request(id = 1)
    self.new( id: id, course: Course.test_data, title: "Journal File Request", creator: 'Fox, Rob', journal_title: "Journal", length: "pages: 33-44", file: "/uploads/test.pdf")
  end


  def self.test_url_request(id = 1)
    self.new( id: id, course: Course.test_data, title: "Journal Url Request", creator: 'Wetheril, Andy', journal_title: "Journal", length: "pgs: 55-66", url: "http://www.google.com/")
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


class VideoListing < CourseListing
  def self.test_request(id = 1)
    self.new( id: id, course: Course.test_data, title: "Movie", creator: 'Robin Schaaf', student_comments: "Be sure to catch the after credits moment with spider robot Chewbacca", length: "42:33 20 min.", url: "http://www.google.com/")
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


class AudioListing < CourseListing

  def self.test_request(id = 1)
    self.new( id: id, course: Course.test_data, title: "Audio", creator: 'Music Person', length: "3:33 15 min.", url: "http://www.google.com/")
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


class WebsiteListing < CourseListing

  def self.test_request(id = 1)
    self.new( id: id,  course: Course.test_data, title: "websites article", creator: 'Super Online Writer', journal_title: 'WEBSITE!!', length: "", url: "http://www.google.com/")
  end


  def list_partial
    'external/request/lists/website_listing'
  end


  def approval_required?
    return false
  end


  def tags
    []
  end


  def css_class
    "record-article"
  end


  def link_to_get_listing?
    true
  end


  def status
    'complete'
  end


end

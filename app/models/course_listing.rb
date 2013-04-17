class CourseListing

  attr_accessor :title, :creator, :journal_title, :length, :file, :url, :course, :id

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


  def tags
    []
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

end


class VideoListing < CourseListing
  def self.test_request(id = 1)
    self.new( id: id, course: Course.test_data, title: "Movie", creator: 'Robin Schaaf', length: "42:33 20 min.", url: "http://www.google.com/")
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
end

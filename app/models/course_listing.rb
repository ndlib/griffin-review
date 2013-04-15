class CourseListing

  attr_accessor :title, :creator, :journal_title, :length, :file, :url

  def initialize(attributes = {})
    attributes.keys.each do  | key |
      self.send("#{key}=", attributes[key])
    end
  end


  def list_partial
    'external/request/lists/basic_listing'
  end


end



class BookListing < CourseListing

  def self.test_request
    self.new( title: "Book Request", creator: 'Author, Author')
  end

end


class BookChapterListing < CourseListing

  def self.test_request
    self.new( title: "Book Chapter Request", creator: 'Author, Author', length: "Chapter 7", file: "FILE")
  end


  def list_partial
    'external/request/lists/book_chapter_listing'
  end
end


class JournalListing < CourseListing

  def self.test_file_request
    self.new( title: "Journal File Request", creator: 'Author, Author', journal_title: "Journal", length: "pages: 33-44", file: "FILE")
  end


  def self.test_url_request
    self.new( title: "Journal Url Request", creator: 'Author, Author', journal_title: "Journal", length: "pgs: 55-66", url: "URL")
  end


  def list_partial
    'external/request/lists/journal_listing'
  end
end


class VideoListing < CourseListing
  def self.test_request
    self.new( title: "Movie", creator: 'Directory', length: "42:33 20 min.", file: "FILE")
  end


  def list_partial
    'external/request/lists/video_listing'
  end
end


class AudioListing < CourseListing
  def self.test_request
    self.new( title: "Audio", creator: 'author', length: "3:33 15 min.", file: "FILE")
  end


  def list_partial
    'external/request/lists/audio_listing'
  end
end


class WebsiteListing < CourseListing
  def self.test_request
    self.new( title: "websites article", creator: 'author', journal_title: 'WEBSITE!!', length: "", url: "URL")
  end


  def list_partial
    'external/request/lists/website_listing'
  end
end

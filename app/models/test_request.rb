class TestRequest < ActiveRecord::Base
  store :data, accessors: [ :issn, :volume, :issue, :journal, :length ]

end


class BookRequest < TestRequest

  def self.test_request
    b = self.new()
    b.title = 'Book Request'
    b.author = 'Author, Author'
    b
  end
end


class BookChapterRequest < TestRequest

end


class JournalRequest < TestRequest

end



class TestRequestPage < SimpleDelegator

  def initialize(request)
    super(request)
  end


  def list_partial
    'external/request/lists/book_request'
  end


  def show_partial

  end

end

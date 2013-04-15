require 'spec_helper'
CourseListing

describe BookChapterListing do

  let(:listing) { BookChapterListing.new(title: "title", creator: "Author", length:"33-44", file: "File" ) }


  it "has a listing partial" do
    listing.list_partial.should == 'external/request/lists/book_chapter_listing'
  end
end

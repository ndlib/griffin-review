require 'spec_helper'
Reserve

describe BookChapterReserve do

  let(:listing) { BookChapterReserve.new(title: "title", creator: "Author", length:"33-44", file: "File" ) }


  it "has a listing partial" do
    listing.list_partial.should == 'external/request/lists/book_chapter_listing'
  end


  it "has a css class to identify this" do
    listing.css_class.should == 'book-record'
  end


  it "links to a get listing page" do
    listing.link_to_get_listing?.should be_true
  end


  describe :approval_required? do

    it "always returns true" do
      listing.approval_required?.should be_true
    end

  end
end

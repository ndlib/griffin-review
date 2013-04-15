require 'spec_helper'
CourseListing

describe JournalListing do

  let(:listing) { JournalListing.new(title: "title", creator: "Author", length:"33-44", file: "File" ) }


  it "has a listing partial" do
    listing.list_partial.should == 'external/request/lists/journal_listing'
  end
end

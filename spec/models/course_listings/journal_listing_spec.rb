require 'spec_helper'
CourseListing

describe JournalListing do

  let(:listing) { JournalListing.new(title: "title", creator: "Author", length:"33-44", file: "File" ) }


  it "has a listing partial" do
    listing.list_partial.should == 'external/request/lists/journal_listing'
  end



  describe :approval_required? do

    it "returns true if their is a file" do
      listing.approval_required?.should be_true
    end


    it "returns false if there is not a file but a url" do
      listing.file = ""
      listing.approval_required?.should be_false
    end

  end
end

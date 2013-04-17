require 'spec_helper'
CourseListing

describe BookListing do

  let(:listing) { BookListing.new(title: "title", creator: "Author" ) }


  it "has a listing partial" do
    listing.list_partial.should == 'external/request/lists/basic_listing'
  end


  describe :approval_required? do

    it "always returns false" do
      listing.approval_required?.should be_false
    end

  end
end

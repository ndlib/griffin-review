require 'spec_helper'
CourseListing

describe AudioListing do

  let(:listing) { AudioListing.new(title: "title", creator: "Author", length:"33-44", file: "File" ) }


  it "has a listing partial" do
    listing.list_partial.should == 'external/request/lists/audio_listing'
  end


  describe :approval_required? do

    it "always returns true" do
      listing.approval_required?.should be_true
    end

  end
end

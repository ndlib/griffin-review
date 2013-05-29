require 'spec_helper'
Reserve

describe JournalReserve do

  let(:listing) { JournalReserve.new(title: "title", creator: "Author", length:"33-44", file: "File" ) }



  it "has a css class to identify this" do
    listing.css_class.should == 'record-article'
  end


  it "links to a get listing page" do
    listing.link_to_get_listing?.should be_true
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

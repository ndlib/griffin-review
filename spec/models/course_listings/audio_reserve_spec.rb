require 'spec_helper'
Reserve

describe AudioReserve do

  let(:listing) { AudioReserve.new(title: "title", creator: "Author", length:"33-44", file: "File" ) }


  it "has a css class to identify this" do
    listing.css_class.should == 'record-audio'
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

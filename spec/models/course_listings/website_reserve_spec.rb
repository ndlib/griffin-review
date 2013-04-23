require 'spec_helper'
Reserve

describe WebsiteReserve do

  let(:listing) { WebsiteReserve.new(title: "title", creator: "Author", journal_title: "WEBSITE", length:"3:23 5 minutes", file: "url" ) }


  it "has a listing partial" do
    listing.list_partial.should == 'external/request/lists/website_listing'
  end

    it "has a css class to identify this" do
    listing.css_class.should == 'record-article'
  end


  it "links to a get listing page" do
    listing.link_to_get_listing?.should be_true
  end


  describe :approval_required? do

    it "always returns false" do
      listing.approval_required?.should be_false
    end

  end


end

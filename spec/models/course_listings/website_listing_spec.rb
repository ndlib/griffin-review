require 'spec_helper'
CourseListing

describe WebsiteListing do

  let(:listing) { WebsiteListing.new(title: "title", creator: "Author", journal_title: "WEBSITE", length:"3:23 5 minutes", file: "url" ) }


  it "has a listing partial" do
    listing.list_partial.should == 'external/request/lists/website_listing'
  end


  describe :approval_required? do

    it "always returns false" do
      listing.approval_required?.should be_false
    end

  end


end

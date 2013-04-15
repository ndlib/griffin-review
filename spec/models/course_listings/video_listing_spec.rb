require 'spec_helper'
CourseListing

describe VideoListing do

  let(:listing) { VideoListing.new(title: "title", creator: "Author", length:"33-44", file: "File" ) }


  it "has a listing partial" do
    listing.list_partial.should == 'external/request/lists/video_listing'
  end
end

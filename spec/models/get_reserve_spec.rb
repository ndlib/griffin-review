require 'spec_helper'

describe GetReserve do

  before(:each) do
    @course_listing = double(GetReserve)
    @current_user = FactoryGirl.create(:student)
  end


  describe :approval_required? do

    it "returns true if there is no approval for the current listing and it needs one" do
      @course_listing.stub!(:approval_required?).and_return(true)

      gcl = GetReserve.new(@course_listing)
      gcl.approval_required?.should be_true
    end

    it "returns false if the item needs not approval" do
      @course_listing.stub!(:approval_required?).and_return(false)

      gcl = GetReserve.new(@course_listing)
      gcl.approval_required?.should be_false
    end

    it "returns false if the item terms needs approval and it has been approved" do
      @course_listing.stub!(:approval_required?).and_return(true)
      @course_listing.stub!(:term_of_service_approved?).and_return(true)

      gcl = GetReserve.new(@course_listing)
      gcl.approval_required?.should be_true
    end
  end


  describe :download_listing? do
    it "returns true if the listing should download a file" do
      @course_listing.stub!(:file).and_return("FILE")

      gcl = GetReserve.new(@course_listing)
      gcl.download_listing?.should be_true
    end

    it "returns false if the listing should not download a file"  do
      @course_listing.stub!(:file).and_return(nil)

      gcl = GetReserve.new(@course_listing)
      gcl.download_listing?.should be_false
    end
  end


  describe :download_file_path do

    it "returns the path the to file for download" do
      @course_listing.stub!(:file).and_return("FILE")

      gcl = GetReserve.new(@course_listing)
      gcl.download_file_path.include?("FILE").should be_true
    end

  end


  describe :redirect_to_listing? do
    it "returns true if the listing should redirect to an external resource" do
      @course_listing.stub!(:url).and_return("URL")

      gcl = GetReserve.new(@course_listing)
      gcl.redirect_to_listing?.should be_true
    end

    it "returns false if the listing should not redirect" do
      @course_listing.stub!(:url).and_return(nil)

      gcl = GetReserve.new(@course_listing)
      gcl.redirect_to_listing?.should be_false
    end
  end


  describe :redirect_uri do

    it "returns the uri to redirect to" do
      @course_listing.stub!(:url).and_return("URL")

      gcl = GetReserve.new(@course_listing)
      gcl.redirect_uri.should == "URL"
    end
  end


  describe :approve_terms_of_service! do

    it "approves the terms of service for the current user" do
      gcl = GetReserve.new(@course_listing)
      gcl.approve_terms_of_service!
      gcl.term_of_service_approved?.should be_true
    end


    it "defaults to false if there is no approval" do
      gcl = GetReserve.new(@course_listing)
      gcl.term_of_service_approved?.should be_false
    end

  end



  describe :link_to_listing? do

    before(:each) do
      @get_reserve = GetReserve.new(@course_listing)
    end


    it "returns true if the listing requires a download" do
      @get_reserve.stub!(:download_listing?).and_return(true)
      @get_reserve.stub!(:redirect_to_listing?).and_return(false)
      @get_reserve.stub!(:reserve_in_current_semester?).and_return(true)

      @get_reserve.link_to_listing?.should be_true
    end

    it "returns true if the listing requires a redirect"  do
      @get_reserve.stub!(:download_listing?).and_return(false)
      @get_reserve.stub!(:redirect_to_listing?).and_return(true)
      @get_reserve.stub!(:reserve_in_current_semester?).and_return(true)

      @get_reserve.link_to_listing?.should be_true
    end

    it "returns false if the listing does not require either a download or a redirect" do
      @get_reserve.stub!(:download_listing?).and_return(false)
      @get_reserve.stub!(:redirect_to_listing?).and_return(false)
      @get_reserve.stub!(:reserve_in_current_semester?).and_return(true)

      @get_reserve.link_to_listing?.should be_false
    end

    it "returns false if the reserve is not in the current semester" do
      @get_reserve.stub!(:download_listing?).and_return(true)
      @get_reserve.stub!(:redirect_to_listing?).and_return(false)
      @get_reserve.stub!(:reserve_in_current_semester?).and_return(false)

      @get_reserve.link_to_listing?.should be_false
    end
  end

end
